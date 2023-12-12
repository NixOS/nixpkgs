{
  # General callPackage-supplied arguments
  autoAddOpenGLRunpathHook,
  autoPatchelfHook,
  backendStdenv,
  fetchurl,
  lib,
  lndir,
  markForCudatoolkitRootHook,
  flags,
  stdenv,
  hostPlatform,
  # Builder-specific arguments
  # Short package name (e.g., "cuda_cccl")
  # pname : String
  pname,
  # Common name (e.g., "cutensor" or "cudnn") -- used in the URL.
  # Also known as the Redistributable Name.
  # redistName : String,
  redistName,
  # If libPath is non-null, it must be a subdirectory of `lib`.
  # The contents of `libPath` will be moved to the root of `lib`.
  libPath ? null,
  # See ./modules/generic/manifests/redistrib/release.nix
  redistribRelease,
  # See ./modules/generic/manifests/feature/release.nix
  featureRelease,
}:
let
  inherit (lib)
    attrsets
    lists
    meta
    strings
    trivial
    licenses
    teams
    sourceTypes
    ;

  # Get the redist architectures for which package provides distributables.
  # These are used by meta.platforms.
  supportedRedistArchs = builtins.attrNames featureRelease;
  redistArch = flags.getRedistArch hostPlatform.system;
in
backendStdenv.mkDerivation (
  finalAttrs: {
    # NOTE: Even though there's no actual buildPhase going on here, the derivations of the
    # redistributables are sensitive to the compiler flags provided to stdenv. The patchelf package
    # is sensitive to the compiler flags provided to stdenv, and we depend on it. As such, we are
    # also sensitive to the compiler flags provided to stdenv.
    inherit pname;
    inherit (redistribRelease) version;

    # Don't force serialization to string for structured attributes, like outputToPatterns
    # and brokenConditions.
    # Avoids "set cannot be coerced to string" errors.
    __structuredAttrs = true;

    # Keep better track of dependencies.
    strictDeps = true;

    # NOTE: Outputs are evaluated jointly with meta, so in the case that this is an unsupported platform,
    # we still need to provide a list of outputs.
    outputs =
      let
        # Checks whether the redistributable provides an output.
        hasOutput =
          output:
          attrsets.attrByPath
            [
              redistArch
              "outputs"
              output
            ]
            false
            featureRelease;
        # Order is important here so we use a list.
        additionalOutputs = builtins.filter hasOutput [
          "bin"
          "lib"
          "static"
          "dev"
          "doc"
          "sample"
          "python"
        ];
        # The out output is special -- it's the default output and we always include it.
        outputs = ["out"] ++ additionalOutputs;
      in
      outputs;

    # Traversed in the order of the outputs speficied in outputs;
    # entries are skipped if they don't exist in outputs.
    outputToPatterns = {
      bin = ["bin"];
      lib = [
        "lib"
        "lib64"
      ];
      static = ["**/*.a"];
      sample = ["samples"];
      python = ["**/*.whl"];
    };

    # Useful for introspecting why something went wrong.
    # Maps descriptions of why the derivation would be marked broken to
    # booleans indicating whether that description is true.
    brokenConditions = {};

    src = fetchurl {
      url = "https://developer.download.nvidia.com/compute/${redistName}/redist/${
        redistribRelease.${redistArch}.relative_path
      }";
      inherit (redistribRelease.${redistArch}) sha256;
    };

    # We do need some other phases, like configurePhase, so the multiple-output setup hook works.
    dontBuild = true;

    nativeBuildInputs = [
      autoPatchelfHook
      # This hook will make sure libcuda can be found
      # in typically /lib/opengl-driver by adding that
      # directory to the rpath of all ELF binaries.
      # Check e.g. with `patchelf --print-rpath path/to/my/binary
      autoAddOpenGLRunpathHook
      markForCudatoolkitRootHook
    ];

    buildInputs =
      [
        # autoPatchelfHook will search for a libstdc++ and we're giving it
        # one that is compatible with the rest of nixpkgs, even when
        # nvcc forces us to use an older gcc
        # NB: We don't actually know if this is the right thing to do
        stdenv.cc.cc.lib
      ];

    # Picked up by autoPatchelf
    # Needed e.g. for libnvrtc to locate (dlopen) libnvrtc-builtins
    appendRunpaths = ["$ORIGIN"];

    # NOTE: We don't need to check for dev or doc, because those outputs are handled by
    # the multiple-outputs setup hook.
    # NOTE: moveToOutput operates on all outputs:
    # https://github.com/NixOS/nixpkgs/blob/2920b6fc16a9ed5d51429e94238b28306ceda79e/pkgs/build-support/setup-hooks/multiple-outputs.sh#L105-L107
    installPhase =
      let
        mkMoveToOutputCommand =
          output:
          let
            template = pattern: ''moveToOutput "${pattern}" "${"$" + output}"'';
            patterns = finalAttrs.outputToPatterns.${output} or [];
          in
          strings.concatMapStringsSep "\n" template patterns;
      in
      # Pre-install hook
      ''
        runHook preInstall
      ''
      # Handle the existence of libPath, which requires us to re-arrange the lib directory
      + strings.optionalString (libPath != null) ''
        if [[ ! -d "${libPath}" ]] ; then
          echo "${finalAttrs.pname}: ${libPath} does not exist, only found:" >&2
          find "$(dirname ${libPath})"/ -maxdepth 1 >&2
          echo "This release might not support your CUDA version" >&2
          exit 1
        fi
        mv "lib/${libPath}" lib_new
        rm -r lib
        mv lib_new lib
      ''
      # Create the primary output, out, and move the other outputs into it.
      + ''
        mkdir -p "$out"
        mv * "$out"
      ''
      # Move the outputs into their respective outputs.
      + strings.concatMapStringsSep "\n" mkMoveToOutputCommand (builtins.tail finalAttrs.outputs)
      # Post-install hook
      + ''
        runHook postInstall
      '';

    # libcuda needs to be resolved during runtime
    # NOTE: Due to the use of __structuredAttrs, we can't use a list for autoPatchelfIgnoreMissingDeps, since it
    # will take only the first value. Instead, we produce a string with the values separated by spaces.
    # Using the `env` attribute ensures that the value is representable as one of the primitives allowed by
    # bash's environment variables.
    env.autoPatchelfIgnoreMissingDeps = "libcuda.so libcuda.so.*";

    # The out output leverages the same functionality which backs the `symlinkJoin` function in
    # Nixpkgs:
    # https://github.com/NixOS/nixpkgs/blob/d8b2a92df48f9b08d68b0132ce7adfbdbc1fbfac/pkgs/build-support/trivial-builders/default.nix#L510
    #
    # That should allow us to emulate "fat" default outputs without having to actually create them.
    #
    # It is important that this run after the autoPatchelfHook, otherwise the symlinks in out will reference libraries in lib, creating a circular dependency.
    postPhases = ["postPatchelf"];

    # For each output, create a symlink to it in the out output.
    # NOTE: We must recreate the out output here, because the setup hook will have deleted it if it was empty.
    postPatchelf = ''
      mkdir -p "$out"
      for output in $(getAllOutputNames); do
        if [[ "$output" != "out" ]]; then
          ${meta.getExe lndir} "''${!output}" "$out"
        fi
      done
    '';

    # Make the CUDA-patched stdenv available
    passthru.stdenv = backendStdenv;

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

    meta = {
      description = "${redistribRelease.name}. By downloading and using the packages you accept the terms and conditions of the ${finalAttrs.meta.license.shortName}";
      sourceProvenance = [sourceTypes.binaryNativeCode];
      platforms =
        lists.concatMap
          (
            redistArch:
            let
              nixSystem = builtins.tryEval (flags.getNixSystem redistArch);
            in
            if nixSystem.success then [nixSystem.value] else []
          )
          supportedRedistArchs;
      broken = lists.any trivial.id (attrsets.attrValues finalAttrs.brokenConditions);
      license = licenses.unfree;
      maintainers = teams.cuda.members;
      # Force the use of the default, fat output by default (even though `dev` exists, which
      # causes Nix to prefer that output over the others if outputSpecified isn't set).
      outputsToInstall = ["out"];
    };
  }
)
