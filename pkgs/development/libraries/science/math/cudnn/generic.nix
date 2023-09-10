{ stdenv,
  backendStdenv,
  lib,
  lndir,
  zlib,
  useCudatoolkitRunfile ? false,
  cudaVersion,
  cudaMajorVersion,
  cudatoolkit, # For cuda < 11
  libcublas ? null, # cuda <11 doesn't ship redist packages
  autoPatchelfHook,
  autoAddOpenGLRunpathHook,
  fetchurl,
}: {
  version,
  url,
  hash,
  minCudaVersion,
  maxCudaVersion,
}:
assert useCudatoolkitRunfile || (libcublas != null); let
  inherit (lib) lists strings trivial versions;

  # majorMinorPatch :: String -> String
  majorMinorPatch = (trivial.flip trivial.pipe) [
    (versions.splitVersion)
    (lists.take 3)
    (strings.concatStringsSep ".")
  ];

  # versionTriple :: String
  # Version with three components: major.minor.patch
  versionTriple = majorMinorPatch version;

  # cudatoolkit_root :: Derivation
  cudatoolkit_root =
    if useCudatoolkitRunfile
    then cudatoolkit
    else libcublas;
in
  backendStdenv.mkDerivation {
    pname = "cudatoolkit-${cudaMajorVersion}-cudnn";
    version = versionTriple;
    strictDeps = true;
    outputs = ["out" "lib" "static" "dev"];

    src = fetchurl {
      inherit url hash;
    };

    # We do need some other phases, like configurePhase, so the multiple-output setup hook works.
    dontBuild = true;

    # Check and normalize Runpath against DT_NEEDED using autoPatchelf.
    # Prepend /run/opengl-driver/lib using addOpenGLRunpath for dlopen("libcudacuda.so")
    nativeBuildInputs = [
      autoPatchelfHook
      autoAddOpenGLRunpathHook
    ];

    # Used by autoPatchelfHook
    buildInputs = [
      # Note this libstdc++ isn't from the (possibly older) nvcc-compatible
      # stdenv, but from the (newer) stdenv that the rest of nixpkgs uses
      stdenv.cc.cc.lib

      zlib
      cudatoolkit_root
    ];

    # We used to patch Runpath here, but now we use autoPatchelfHook
    #
    # Note also that version <=8.3.0 contained a subdirectory "lib64/" but in
    # version 8.3.2 it seems to have been renamed to simply "lib/".
    #
    # doc and dev have special output handling. Other outputs need to be moved to their own
    # output.
    # Note that moveToOutput operates on all outputs:
    # https://github.com/NixOS/nixpkgs/blob/2920b6fc16a9ed5d51429e94238b28306ceda79e/pkgs/build-support/setup-hooks/multiple-outputs.sh#L105-L107
    installPhase =
      ''
        runHook preInstall

        mkdir -p "$out"
        mv * "$out"
        moveToOutput "lib64" "$lib"
        moveToOutput "lib" "$lib"
        moveToOutput "**/*.a" "$static"

        runHook postInstall
      '';

    # Without --add-needed autoPatchelf forgets $ORIGIN on cuda>=8.0.5.
    postFixup = strings.optionalString (strings.versionAtLeast versionTriple "8.0.5") ''
      patchelf $lib/lib/libcudnn.so --add-needed libcudnn_cnn_infer.so
      patchelf $lib/lib/libcudnn_ops_infer.so --add-needed libcublas.so --add-needed libcublasLt.so
    '';

    # The out output leverages the same functionality which backs the `symlinkJoin` function in
    # Nixpkgs:
    # https://github.com/NixOS/nixpkgs/blob/d8b2a92df48f9b08d68b0132ce7adfbdbc1fbfac/pkgs/build-support/trivial-builders/default.nix#L510
    #
    # That should allow us to emulate "fat" default outputs without having to actually create them.
    #
    # It is important that this run after the autoPatchelfHook, otherwise the symlinks in out will reference libraries in lib, creating a circular dependency.
    postPhases = ["postPatchelf"];
    # For each output, create a symlink to it in the out output.
    # NOTE: We must recreate the out output here, because the setup hook will have deleted it
    # if it was empty.
    # NOTE: Do not use optionalString based on whether `outputs` contains only `out` -- phases
    # which are empty strings are skipped/unset and result in errors of the form "command not
    # found: <customPhaseName>".
    postPatchelf = ''
      mkdir -p "$out"
      ${lib.meta.getExe lndir} "$lib" "$out"
      ${lib.meta.getExe lndir} "$static" "$out"
      ${lib.meta.getExe lndir} "$dev" "$out"
    '';

    passthru = {
      inherit useCudatoolkitRunfile;

      cudatoolkit =
        trivial.warn
        ''
          cudnn.cudatoolkit passthru attribute is deprecated;
          if your derivation uses cudnn directly, it should probably consume cudaPackages instead
        ''
        cudatoolkit;

      majorVersion = versions.major versionTriple;
    };

    # Setting propagatedBuildInputs to false will prevent outputs known to the multiple-outputs
    # from depending on `out` by default.
    # https://github.com/NixOS/nixpkgs/blob/2920b6fc16a9ed5d51429e94238b28306ceda79e/pkgs/build-support/setup-hooks/multiple-outputs.sh#L196
    # Indeed, we want to do the opposite -- fat "out" outputs that contain all the other outputs.
    propagatedBuildOutputs = false;

    # By default, if the dev output exists it just uses that.
    # However, because we disabled propagatedBuildOutputs, dev doesn't contain libraries or
    # anything of the sort. To remedy this, we set outputSpecified to true, and use
    # outputsToInstall, which tells Nix which outputs to use when the package name is used
    # unqualified (that is, without an explicit output).
    outputSpecified = true;

    meta = with lib; {
      # Check that the cudatoolkit version satisfies our min/max constraints (both
      # inclusive). We mark the package as broken if it fails to satisfies the
      # official version constraints (as recorded in default.nix). In some cases
      # you _may_ be able to smudge version constraints, just know that you're
      # embarking into unknown and unsupported territory when doing so.
      broken =
        strings.versionOlder cudaVersion minCudaVersion
        || strings.versionOlder maxCudaVersion cudaVersion;
      description = "NVIDIA CUDA Deep Neural Network library (cuDNN)";
      homepage = "https://developer.nvidia.com/cudnn";
      sourceProvenance = with sourceTypes; [binaryNativeCode];
      # TODO: consider marking unfreRedistributable when not using runfile
      license = licenses.unfree;
      platforms = ["x86_64-linux"];
      maintainers = with maintainers; [mdaiter samuela];
      # Force the use of the default, fat output by default (even though `dev` exists, which
      # causes Nix to prefer that output over the others if outputSpecified isn't set).
      outputsToInstall = ["out"];
    };
  }
