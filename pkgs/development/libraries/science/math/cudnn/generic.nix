{ stdenv,
  backendStdenv,
  lib,
  zlib,
  useCudatoolkitRunfile ? false,
  cudaVersion,
  cudaMajorVersion,
  cudatoolkit, # For cuda < 11
  libcublas ? null, # cuda <11 doesn't ship redist packages
  autoPatchelfHook,
  autoAddOpenGLRunpathHook,
  fetchurl,
  # The distributed version of CUDNN includes both dynamically liked .so files,
  # as well as statically linked .a files.  However, CUDNN is quite large
  # (multiple gigabytes), so you can save some space in your nix store by
  # removing the statically linked libraries if you are not using them.
  #
  # Setting this to true removes the statically linked .a files.
  # Setting this to false keeps these statically linked .a files.
  removeStatic ? false,
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

    src = fetchurl {
      inherit url hash;
    };

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
    installPhase =
      ''
        runHook preInstall

        mkdir -p $out
        cp -a include $out/include
        [ -d "lib/" ] && cp -a lib $out/lib
        [ -d "lib64/" ] && cp -a lib64 $out/lib64
      ''
      + strings.optionalString removeStatic ''
        rm -f $out/lib/*.a
        rm -f $out/lib64/*.a
      ''
      + ''
        runHook postInstall
      '';

    # Without --add-needed autoPatchelf forgets $ORIGIN on cuda>=8.0.5.
    postFixup = strings.optionalString (strings.versionAtLeast versionTriple "8.0.5") ''
      patchelf $out/lib/libcudnn.so --add-needed libcudnn_cnn_infer.so
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
    };
  }
