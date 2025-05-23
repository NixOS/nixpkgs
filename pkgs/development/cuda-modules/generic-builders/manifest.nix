{
  # General callPackage-supplied arguments
  autoAddDriverRunpath,
  autoAddCudaCompatRunpath,
  autoPatchelfHook,
  backendStdenv,
  callPackage,
  _cuda,
  fetchurl,
  lib,
  markForCudatoolkitRootHook,
  flags,
  stdenv,
  # Builder-specific arguments
  # Short package name (e.g., "cuda_cccl")
  # pname : String
  pname,
  # version : String
  version,
  # Maybe { URL, SHA256, ... }
  src,
  # If libPath is non-null, it must be a subdirectory of `lib`.
  # The contents of `libPath` will be moved to the root of `lib`.
  libPath ? null,
  cudaMajorMinorVersion,
}:
let
  inherit (lib)
    attrsets
    lists
    strings
    trivial
    teams
    sourceTypes
    ;

  systemsNv = _cuda.db.package.systemsNv.${pname};

  # Last step before returning control to `callPackage` (adds the `.override` method)
  # we'll apply (`overrideAttrs`) necessary package-specific "fixup" functions.
  # Order is significant.
  maybeFixup = _cuda.fixups.${pname} or null;
  fixup = if maybeFixup != null then callPackage maybeFixup { } else { };
in
(backendStdenv.mkDerivation (finalAttrs: {
  # NOTE: Even though there's no actual buildPhase going on here, the derivations of the
  # redistributables are sensitive to the compiler flags provided to stdenv. The patchelf package
  # is sensitive to the compiler flags provided to stdenv, and we depend on it. As such, we are
  # also sensitive to the compiler flags provided to stdenv.

  inherit pname version;
  src = lib.mapNullable (
    { url, sha256, ... }:
    fetchurl {
      inherit url sha256;
    }
  ) src;

  # Don't force serialization to string for structured attributes, like outputToPatterns
  # and brokenConditions.
  # Avoids "set cannot be coerced to string" errors.
  __structuredAttrs = true;

  # Keep better track of dependencies.
  strictDeps = true;

  outputs = lib.attrNames _cuda.db.package.outputs.${pname};

  # Traversed in the order of the outputs specified in outputs;
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
    "No source" = finalAttrs.src == null;
  };

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

  passthru = {
    # Make the CUDA-patched stdenv available
    stdenv = backendStdenv;
  };

  meta = {
    description = "${_cuda.db.package.name.${pname}}. By downloading and using the packages you accept the terms and conditions of the ${finalAttrs.meta.license.fullName}";
    sourceProvenance =
      if _cuda.db.system.isSource.${src.systemNv or ""} or false then
        [ sourceTypes.fromSource ]
      else
        [ sourceTypes.binaryNativeCode ];
    broken = lists.any trivial.id (attrsets.attrValues finalAttrs.brokenConditions);
    platforms = lib.attrNames (
      lib.concatMapAttrs (systemNv: _: _cuda.db.system.fromNvidia.${systemNv}) systemsNv
    );
    badPlatforms =
      let
        isBadPlatform = lists.any trivial.id (attrsets.attrValues finalAttrs.badPlatformsConditions);
      in
      lists.optionals isBadPlatform finalAttrs.meta.platforms;
    license = _cuda.db.license.compiled.${_cuda.db.package.license.${pname}};
    teams = [ teams.cuda ];
  };
})).overrideAttrs
  fixup
