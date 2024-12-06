{
  # General callPackage-supplied arguments
  autoAddDriverRunpath,
  autoAddCudaCompatRunpath,
  autoPatchelfHook,
  backendStdenv,
  fetchurl,
  lib,
  markForCudatoolkitRootHook,
  flags,
  stdenv,
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
  cudaMajorMinorVersion,
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

  inherit (stdenv) hostPlatform;

  # Get the redist architectures for which package provides distributables.
  # These are used by meta.platforms.
  supportedRedistArchs = builtins.attrNames featureRelease;
  # redistArch :: String
  # The redistArch is the name of the architecture for which the redistributable is built.
  # It is `"unsupported"` if the redistributable is not supported on the target platform.
  redistArch = flags.getRedistArch hostPlatform.system;

  sourceMatchesHost = flags.getNixSystem redistArch == hostPlatform.system;
in
backendStdenv.mkDerivation (finalAttrs: {
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
        attrsets.attrByPath [
          redistArch
          "outputs"
          output
        ] false featureRelease;
      # Order is important here so we use a list.
      possibleOutputs = [
        "bin"
        "lib"
        "static"
        "dev"
        "doc"
        "sample"
        "python"
      ];
      # Filter out outputs that don't exist in the redistributable.
      # NOTE: In the case the redistributable isn't supported on the target platform,
      # we will have `outputs = [ "out" ] ++ possibleOutputs`. This is of note because platforms which
      # aren't supported would otherwise have evaluation errors when trying to access outputs other than `out`.
      # The alternative would be to have `outputs = [ "out" ]` when`redistArch = "unsupported"`, but that would
      # require adding guards throughout the entirety of the CUDA package set to ensure `cudaSupport` is true --
      # recall that OfBorg will evaluate packages marked as broken and that `cudaPackages` will be evaluated with
      # `cudaSupport = false`!
      additionalOutputs =
        if redistArch == "unsupported" then possibleOutputs else builtins.filter hasOutput possibleOutputs;
      # The out output is special -- it's the default output and we always include it.
      outputs = [ "out" ] ++ additionalOutputs;
    in
    outputs;

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
  };

  # Useful for introspecting why something went wrong. Maps descriptions of why the derivation would be marked as
  # broken on have badPlatforms include the current platform.

  # brokenConditions :: AttrSet Bool
  # Sets `meta.broken = true` if any of the conditions are true.
  # Example: Broken on a specific version of CUDA or when a dependency has a specific version.
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
  # Example: Broken on a specific architecture when some condition is met (like targeting Jetson).
  badPlatformsConditions = {
    "No source" = !sourceMatchesHost;
  };

  # src :: Optional Derivation
  # If redistArch doesn't exist in redistribRelease, return null.
  src = trivial.mapNullable (
    { relative_path, sha256, ... }:
    fetchurl {
      url = "https://developer.download.nvidia.com/compute/${redistName}/redist/${relative_path}";
      inherit sha256;
    }
  ) (redistribRelease.${redistArch} or null);

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
      for pc in share/pkgconfig/*-"$majorMinorVersion.pc"; do
        ln -s "$(basename "$pc")" "''${pc%-$majorMinorVersion.pc}".pc
      done
    '';

  env.majorMinorVersion = cudaMajorMinorVersion;

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
    ++ lib.optionals (pname != "cuda_compat" && flags.isJetsonBuild) [
      # autoAddCudaCompatRunpath must appear AFTER autoAddDriverRunpath.
      # See its documentation in ./setup-hooks/extension.nix.
      autoAddCudaCompatRunpath
    ];

  buildInputs = [
    # autoPatchelfHook will search for a libstdc++ and we're giving it
    # one that is compatible with the rest of nixpkgs, even when
    # nvcc forces us to use an older gcc
    # NB: We don't actually know if this is the right thing to do
    (lib.getLib stdenv.cc.cc)
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
    # Handle the existence of libPath, which requires us to re-arrange the lib directory
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
    + strings.concatMapStringsSep "\n" mkMoveToOutputCommand (builtins.tail finalAttrs.outputs)
    # Add a newline to the end of the installPhase, so that the post-install hook doesn't
    # get concatenated with the last moveToOutput command.
    + "\n"
    # Post-install hook
    + ''
      runHook postInstall
    '';

  doInstallCheck = true;
  allowFHSReferences = true; # TODO: Default to `false`
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

  # _multioutPropagateDev() currently expects a space-separated string rather than an array
  preFixup = ''
    export propagatedBuildOutputs="''${propagatedBuildOutputs[@]}"
  '';

  # Propagate all outputs, including `static`
  propagatedBuildOutputs = builtins.filter (x: x != "dev") finalAttrs.outputs;

  # Kept in case overrides assume postPhases have already been defined
  postPhases = [ "postPatchelf" ];
  postPatchelf = ''
    true
  '';

  # Make the CUDA-patched stdenv available
  passthru.stdenv = backendStdenv;

  meta = {
    description = "${redistribRelease.name}. By downloading and using the packages you accept the terms and conditions of the ${finalAttrs.meta.license.shortName}";
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
    broken = lists.any trivial.id (attrsets.attrValues finalAttrs.brokenConditions);
    platforms = trivial.pipe supportedRedistArchs [
      # Map each redist arch to the equivalent nix system or null if there is no equivalent.
      (builtins.map flags.getNixSystem)
      # Filter out unsupported systems
      (builtins.filter (nixSystem: !(strings.hasPrefix "unsupported-" nixSystem)))
    ];
    badPlatforms =
      let
        isBadPlatform = lists.any trivial.id (attrsets.attrValues finalAttrs.badPlatformsConditions);
      in
      lists.optionals isBadPlatform finalAttrs.meta.platforms;
    license = licenses.unfree;
    maintainers = teams.cuda.members;
  };
})
