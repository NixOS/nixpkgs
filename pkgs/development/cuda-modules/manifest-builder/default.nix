{
  # Builder-specific arguments
  # src :: null | Derivation
  src,
  # libPath :: null | Path
  libPath,
  # packageInfo :: PackageInfo
  packageInfo,
  # Short package name (e.g., "cuda_cccl")
  # packageName : String
  packageName,
  # releaseInfo :: ReleaseInfo
  releaseInfo,
  # General callPackage-supplied arguments
  autoAddCudaCompatRunpath,
  autoAddDriverRunpath,
  autoPatchelfHook,
  backendStdenv,
  config,
  cudaMajorMinorVersion,
  cudaFlags,
  lib,
  markForCudatoolkitRootHook,
  stdenv,
}:
let
  inherit (lib)
    attrsets
    licenses
    lists
    platforms
    sourceTypes
    strings
    teams
    trivial
    ;
  # Order is important here so we use a list.
  possibleOutputs = [
    "bin"
    "lib"
    "static"
    "dev"
    "doc"
    "sample"
    "python"
    "stubs"
  ];
  # lists.intersectLists iterates over the second list, checking if the elements are in the first list.
  # As such, the order of the output is dictated by the order of the second list.
  componentOutputs = lists.intersectLists packageInfo.feature.outputs possibleOutputs;
in
backendStdenv.mkDerivation (
  finalAttrs:
  let
    isBadPlatform = lists.any trivial.id (attrsets.attrValues finalAttrs.badPlatformsConditions);
    isBroken = lists.any trivial.id (attrsets.attrValues finalAttrs.brokenConditions);
  in
  {
    # NOTE: Even though there's no actual buildPhase going on here, the derivations of the
    # redistributables are sensitive to the compiler flags provided to stdenv. The patchelf package
    # is sensitive to the compiler flags provided to stdenv, and we depend on it. As such, we are
    # also sensitive to the compiler flags provided to stdenv.
    name = "cuda${cudaMajorMinorVersion}-${finalAttrs.pname}-${finalAttrs.version}";
    pname = packageName;
    inherit (releaseInfo) version;

    # Don't force serialization to string for structured attributes, like outputToPatterns
    # and brokenConditions.
    # Avoids "set cannot be coerced to string" errors.
    __structuredAttrs = true;

    # Keep better track of dependencies.
    strictDeps = true;

    outputs = [ "out" ] ++ componentOutputs;

    # Traversed in the order of the outputs speficied in outputs;
    # entries are skipped if they don't exist in outputs.
    outputToPatterns = {
      bin = [ "bin" ];
      dev = [
        "share/pkgconfig"
        "**/*.pc"
        "**/*.cmake"
      ];
      lib = [
        "lib"
        "lib64"
      ];
      static = [ "**/*.a" ];
      sample = [ "samples" ];
      python = [ "**/*.whl" ];
      stubs = [
        "stubs"
        "lib/stubs"
      ];
    };

    # Useful for introspecting why something went wrong. Maps descriptions of why the derivation would be marked as
    # broken on have badPlatforms include the current platform.

    # brokenConditions :: AttrSet Bool
    # Sets `meta.broken = true` if any of the conditions are true.
    # Example: Broken on a specific version of CUDA or when a dependency has a specific version.
    # NOTE: Do not use this when a broken condition means evaluation will fail! For example, if
    # a package is missing and is required for the build -- that should go in badPlatformsConditions,
    # because attempts to access attributes on the package will cause evaluation errors.
    brokenConditions = {
      # Unclear how this is handled by Nix internals.
      "Duplicate entries in outputs" = finalAttrs.outputs != lists.unique finalAttrs.outputs;
      # Typically this results in the static output being empty, as all libraries are moved
      # back to the lib output.
      "lib output follows static output" =
        let
          libIndex = lists.findFirstIndex (x: x == "lib") null finalAttrs.outputs;
          staticIndex = lists.findFirstIndex (x: x == "static") null finalAttrs.outputs;
        in
        libIndex != null && staticIndex != null && libIndex > staticIndex;
    };

    # badPlatformsConditions :: AttrSet Bool
    # Sets `meta.badPlatforms = meta.platforms` if any of the conditions are true.
    # Example: Broken on a specific architecture when some condition is met, like targeting Jetson or
    # a required package missing.
    # NOTE: Use this when a broken condition means evaluation can fail!
    badPlatformsConditions = {
      "CUDA support is not enabled" = !config.cudaSupport;
      "Platform is not supported" = finalAttrs.src == null;
    };

    # src :: null | Derivation
    inherit src;

    postPatch =
      # Pkg-config's setup hook expects configuration files in $out/share/pkgconfig
      ''
        for path in pkg-config pkgconfig; do
          [[ -d "$path" ]] || continue
          mkdir -p share/pkgconfig
          mv "$path"/* share/pkgconfig/
          rmdir "$path"
        done
      ''
      # Rewrite FHS paths with store paths
      # NOTE: output* fall back to out if the corresponding output isn't defined.
      + ''
        for pc in share/pkgconfig/*.pc; do
          sed -i \
            -e "s|^cudaroot\s*=.*\$|cudaroot=''${!outputDev}|" \
            -e "s|^libdir\s*=.*/lib\$|libdir=''${!outputLib}/lib|" \
            -e "s|^includedir\s*=.*/include\$|includedir=''${!outputDev}/include|" \
            "$pc"
        done
      ''
      # Generate unversioned names.
      # E.g. cuda-11.8.pc -> cuda.pc
      + ''
        for pc in share/pkgconfig/*-"${cudaMajorMinorVersion}.pc"; do
          ln -s "$(basename "$pc")" "''${pc%-${cudaMajorMinorVersion}.pc}".pc
        done
      '';

    # We do need some other phases, like configurePhase, so the multiple-output setup hook works.
    dontBuild = true;

    nativeBuildInputs =
      [
        autoPatchelfHook
        # This hook will make sure libcuda can be found
        # in typically /lib/opengl-driver by adding that
        # directory to the rpath of all ELF binaries.
        # Check e.g. with `patchelf --print-rpath path/to/my/binary
        autoAddDriverRunpath
        markForCudatoolkitRootHook
      ]
      # autoAddCudaCompatRunpath depends on cuda_compat and would cause
      # infinite recursion if applied to `cuda_compat` itself (beside the fact
      # that it doesn't make sense in the first place)
      ++ lists.optionals (finalAttrs.pname != "cuda_compat" && cudaFlags.isJetsonBuild) [
        # autoAddCudaCompatRunpath must appear AFTER autoAddDriverRunpath.
        # See its documentation in ./setup-hooks/extension.nix.
        autoAddCudaCompatRunpath
      ];

    buildInputs = [
      # autoPatchelfHook will search for a libstdc++ and we're giving it
      # one that is compatible with the rest of nixpkgs, even when
      # nvcc forces us to use an older gcc
      # NB: We don't actually know if this is the right thing to do
      stdenv.cc.cc.lib
    ];

    # Picked up by autoPatchelf
    # Needed e.g. for libnvrtc to locate (dlopen) libnvrtc-builtins
    appendRunpaths = [ "$ORIGIN" ];

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
            patterns = finalAttrs.outputToPatterns.${output} or [ ];
          in
          strings.concatMapStringsSep "\n" template patterns;
      in
      # Pre-install hook
      ''
        runHook preInstall
      ''
      # Handle the existence of libPath, which requires us to re-arrange the lib directory.
      + strings.optionalString (libPath != null) ''
        full_lib_path="lib/${libPath}"
        if [[ ! -d "$full_lib_path" ]]; then
          echo "${finalAttrs.pname}: '$full_lib_path' does not exist, only found:" >&2
          find lib/ -mindepth 1 -maxdepth 1 >&2
          echo "This release might not support your CUDA version" >&2
          exit 1
        fi
        echo "Making libPath '$full_lib_path' the root of lib" >&2
        mv "$full_lib_path" lib_new
        rm -r lib
        mv lib_new lib
      ''
      # Create the primary output, out, and move the other outputs into it.
      + ''
        mkdir -p "$out"
        mv * "$out"
      ''
      # Move the outputs into their respective outputs.
      + ''
        ${strings.concatMapStringsSep "\n" mkMoveToOutputCommand (builtins.tail finalAttrs.outputs)}
      ''
      # If there's a `stubs` output, add the setupCudaStubsHook to it.
      # NOTE:
      #   We can't make this a standalone setup hook because of the way the multiple-output setup hook works: we'd run
      #   into infinite recursion errors because the setup hook contains the store path of the `stubs` output.
      #   One way to get around that problem is to template the script inside a phase, like we do here, so the package
      #   itself maintains the store path of the `stubs` output, and we don't cross derivation boundaries, causing
      #   infinite recursion.
      + strings.optionalString (lists.elem "stubs" finalAttrs.outputs) ''
        mkdir -p "$stubs/nix-support"
        cat "${./setup-cuda-stubs-hook.sh}" >> "$stubs/nix-support/setup-hook"
        substituteInPlace "$stubs/nix-support/setup-hook" \
          --replace-fail "@stubs@" "${builtins.placeholder "stubs"}" \
          --replace-fail "@roles@" "${../../../build-support/setup-hooks/role.bash}"
      ''
      # Post-install hook
      + ''
        runHook postInstall
      '';

    doInstallCheck = true;
    allowFHSReferences = false;
    postInstallCheck = ''
      echo "Executing postInstallCheck"

      if [[ -z "''${allowFHSReferences-}" ]]; then
        mapfile -t outputPaths < <(for o in $(getAllOutputNames); do echo "''${!o}"; done)
        if grep --max-count=5 --recursive --exclude=LICENSE /usr/ "''${outputPaths[@]}"; then
          echo "Detected references to /usr" >&2
          exit 1
        fi
      fi
    '';

    # libcuda needs to be resolved during runtime
    autoPatchelfIgnoreMissingDeps = [
      "libcuda.so"
      "libcuda.so.*"
    ];

    # The `out` output should largely be empty save for nix-support/propagated-build-inputs.
    # In effect, this allows us to make `out` depend on all the other components.
    # Add all outputs but out and dev to propagated-build-inputs in out.
    # Dev should contain a reference to out, so we don't need to add it.
    # NOTE: We must use printWords to ensure the output is a single line.
    # See addPkg in ./pkgs/build-support/buildenv/builder.pl -- it splits on spaces.
    postFixup = ''
      mkdir -p "$out/nix-support"
      for output in $(getAllOutputNames); do
        # Skip out output to avoid a cycle
        [[ "$output" == out ]] && continue
        echo "Adding $output to out's propagated-build-inputs"
        printWords "''${!output}" >> "$out/nix-support/propagated-build-inputs"
      done
    '';

    passthru =
      # Make the CUDA-patched stdenv available
      {
        stdenv = backendStdenv;
      }
      # If broken or platform is unsupported, populate passthru with attributes for all possible outputs (besides out).
      # This way, if a consumer of a redist package attempts to access an output which doesn't exist on their platform
      # or configuration, they get an error message about the package being broken or unsupported *instead of* a missing
      # attribute error.
      // attrsets.optionalAttrs (isBroken || isBadPlatform) (
        let
          # Subtract finalAttrs.outputs *from* possibleOutputs to get the outputs that are not in finalAttrs.outputs.
          invalidOutputs = lists.subtractLists finalAttrs.outputs possibleOutputs;
        in
        attrsets.genAttrs invalidOutputs (
          output:
          let
            # Create a variant of the package which is both marked as broken and unsupported.
            packageMarkedAsBrokenAndUnsupported = finalAttrs.finalPackage.overrideAttrs (prevAttrs: {
              brokenConditions = prevAttrs.brokenConditions // {
                "Accessed non-existent output ${output}" = true;
              };
              badPlatformsConditions = prevAttrs.badPlatformsConditions // {
                "Accessed non-existent output ${output}" = true;
              };
            });
          in
          trivial.warn "${finalAttrs.name}.${output} does not exist" packageMarkedAsBrokenAndUnsupported
        )
      );

    # Setting propagatedBuildInputs to false will prevent outputs known to the multiple-outputs
    # from depending on `out` by default.
    # https://github.com/NixOS/nixpkgs/blob/2920b6fc16a9ed5d51429e94238b28306ceda79e/pkgs/build-support/setup-hooks/multiple-outputs.sh#L196
    # Indeed, we want to do the opposite -- fat "out" outputs that contain all the other outputs.
    propagatedBuildOutputs = false;

    # NOTE: This breaks getOutput and the like, but that isn't a bad thing because it means we don't have to
    # worry about the `dev` component being used by default by make-derivation.nix.
    outputSpecified = true;

    meta = {
      description = "${releaseInfo.name}. By downloading and using the packages you accept the terms and conditions of the ${finalAttrs.meta.license.shortName}";
      sourceProvenance = [ sourceTypes.binaryNativeCode ];
      broken = isBroken;
      badPlatforms = lists.optionals isBadPlatform platforms.all;
      license = licenses.unfree;
      maintainers = teams.cuda.members;
      # NOTE: If we do not set the outputsToInstall attribute, the default output is "bin".
      # https://github.com/NixOS/nixpkgs/blob/3b6f808dc92d20687c315f4d443098960301b2c0/pkgs/stdenv/generic/check-meta.nix#L446-L482
      outputsToInstall = [ "out" ];
    };
  }
)
