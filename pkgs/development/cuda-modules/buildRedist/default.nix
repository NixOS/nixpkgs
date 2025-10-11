# NOTE: buildRedist should never take manifests or fixups as callPackage-provided arguments,
# since we want to provide the flexibility to call it directly with a different fixup or manifest.
{
  _cuda,
  autoAddCudaCompatRunpath,
  autoAddDriverRunpath,
  autoPatchelfHook,
  backendStdenv,
  config,
  cudaMajorMinorVersion,
  cudaMajorVersion,
  cudaNamePrefix,
  fetchurl,
  flags,
  lib,
  manifests,
  markForCudatoolkitRootHook,
  setupCudaHook,
  srcOnly,
  stdenv,
}:
let
  inherit (backendStdenv) hostRedistSystem;
  inherit (_cuda.lib) getNixSystems _mkCudaVariant mkRedistUrl;
  inherit (lib.attrsets)
    foldlAttrs
    hasAttr
    isAttrs
    attrNames
    optionalAttrs
    ;
  inherit (lib.customisation) extendMkDerivation;
  inherit (lib.lists)
    naturalSort
    concatMap
    unique
    ;
  inherit (lib.trivial) mapNullable pipe;
  inherit (_cuda.lib) _mkMetaBadPlatforms _mkMetaBroken _redistSystemIsSupported;
  inherit (lib)
    licenses
    sourceTypes
    teams
    ;
  inherit (lib.asserts) assertMsg;
  inherit (lib.lists)
    elem
    findFirst
    findFirstIndex
    foldl'
    intersectLists
    map
    subtractLists
    tail
    ;
  inherit (lib.strings)
    concatMapStringsSep
    toUpper
    stringLength
    substring
    ;
  inherit (lib.trivial) flip;

  mkOutputNameVar =
    output:
    assert assertMsg (output != "") "mkOutputNameVar: output name variable must not be empty";
    "output" + toUpper (substring 0 1 output) + substring 1 (stringLength output - 1) output;

  getSupportedReleases =
    let
      desiredCudaVariant = _mkCudaVariant cudaMajorVersion;
    in
    release:
    # Always show preference to the "source", then "linux-all" redistSystem if they are available, as they are
    # the most general.
    if release ? source then
      {
        inherit (release) source;
      }
    else if release ? linux-all then
      {
        inherit (release) linux-all;
      }
    else
      let
        hasCudaVariants = release ? cuda_variant;
      in
      foldlAttrs (
        acc: name: value:
        acc
        # If the value is an attribute, and when hasCudaVariants is true it has the relevant CUDA variant,
        # then add it to the set.
        // optionalAttrs (isAttrs value && (hasCudaVariants -> hasAttr desiredCudaVariant value)) {
          ${name} = value.${desiredCudaVariant} or value;
        }
      ) { } release;

  getPreferredRelease =
    supportedReleases:
    supportedReleases.source or supportedReleases.linux-all or supportedReleases.${hostRedistSystem}
      or null;
in
extendMkDerivation {
  constructDrv = backendStdenv.mkDerivation;
  # These attributes are moved to passthru to avoid changing derivation hashes.
  excludeDrvArgNames = [
    # Core
    "redistName"
    "release"

    # Misc
    "brokenAssertions"
    "platformAssertions"
    "expectedOutputs"
    "outputToPatterns"
    "outputNameVarFallbacks"
  ];
  extendDrvArgs =
    finalAttrs:
    {
      # Core
      redistName,
      pname,
      release ? manifests.${finalAttrs.passthru.redistName}.${finalAttrs.pname} or null,

      # Outputs
      outputs ? [ "out" ],
      propagatedBuildOutputs ? [ ],

      # Inputs
      nativeBuildInputs ? [ ],
      propagatedBuildInputs ? [ ],
      buildInputs ? [ ],

      # Checking
      doInstallCheck ? true,
      allowFHSReferences ? false,

      # Fixups
      appendRunpaths ? [ ],

      # Extra
      passthru ? { },
      meta ? { },

      # Misc
      brokenAssertions ? [ ],
      platformAssertions ? [ ],

      # Order is important here so we use a list.
      expectedOutputs ? [
        "out"
        "doc"
        "samples"
        "python"
        "bin"
        "dev"
        "include"
        "lib"
        "static"
        "stubs"
      ],

      # Traversed in the order of the outputs speficied in outputs;
      # entries are skipped if they don't exist in outputs.
      # NOTE: The nil LSP gets angry if we do not parenthesize the default attrset.
      outputToPatterns ? {
        bin = [ "bin" ];
        dev = [
          "**/*.pc"
          "**/*.cmake"
        ];
        include = [ "include" ];
        lib = [
          "lib"
          "lib64"
        ];
        static = [ "**/*.a" ];
        samples = [ "samples" ];
        python = [ "**/*.whl" ];
        stubs = [
          "stubs"
          "lib/stubs"
        ];
      },

      # Defines a list of fallbacks for each potential output.
      # The last fallback is the out output.
      # Taken and modified from:
      # https://github.com/NixOS/nixpkgs/blob/fe5e11faed6241aacf7220436088789287507494/pkgs/build-support/setup-hooks/multiple-outputs.sh#L45-L62
      outputNameVarFallbacks ? {
        outputBin = [ "bin" ];
        outputDev = [ "dev" ];
        outputDoc = [ "doc" ];
        outputInclude = [
          "include"
          "dev"
        ];
        outputLib = [ "lib" ];
        outputOut = [ "out" ];
        outputPython = [ "python" ];
        outputSamples = [ "samples" ];
        outputStatic = [ "static" ];
        outputStubs = [ "stubs" ];
      },
      ...
    }:
    {
      __structuredAttrs = true;
      strictDeps = true;

      # NOTE: `release` may be null if a redistributable isn't available.
      version = finalAttrs.passthru.release.version or "0-unsupported";

      # Name should be prefixed by cudaNamePrefix to create more descriptive path names.
      name = "${cudaNamePrefix}-${finalAttrs.pname}-${finalAttrs.version}";

      # We should only have the output `out` when `src` is null.
      # lists.intersectLists iterates over the second list, checking if the elements are in the first list.
      # As such, the order of the output is dictated by the order of the second list.
      outputs =
        if finalAttrs.src == null then
          [ "out" ]
        else
          intersectLists outputs finalAttrs.passthru.expectedOutputs;

      # NOTE: Because the `dev` output is special in Nixpkgs -- make-derivation.nix uses it as the default if
      # it is present -- we must ensure that it brings in the expected dependencies. For us, this means that `dev`
      # should include `bin`, `include`, and `lib` -- `static` is notably absent because it is quite large.
      # We do not include `stubs`, as a number of packages contain stubs for libraries they already ship with!
      # Only a few, like cuda_cudart, actually provide stubs for libraries we're missing.
      # As such, these packages should override propagatedBuildOutputs to add `stubs`.
      propagatedBuildOutputs =
        intersectLists [
          "bin"
          "include"
          "lib"
        ] finalAttrs.outputs
        ++ propagatedBuildOutputs;

      # src :: null | Derivation
      src = mapNullable (
        { relative_path, sha256, ... }:
        srcOnly {
          __structuredAttrs = true;
          strictDeps = true;
          stdenv = backendStdenv;
          inherit (finalAttrs) pname version;
          src = fetchurl {
            url = mkRedistUrl finalAttrs.passthru.redistName relative_path;
            inherit sha256;
          };
        }
      ) (getPreferredRelease finalAttrs.passthru.supportedReleases);

      # Required for the hook.
      inherit cudaMajorMinorVersion cudaMajorVersion;

      # We do need some other phases, like configurePhase, so the multiple-output setup hook works.
      dontBuild = true;

      nativeBuildInputs = [
        ./buildRedistHook.bash
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
      ++ lib.optionals (finalAttrs.pname != "cuda_compat" && autoAddCudaCompatRunpath.enableHook) [
        # autoAddCudaCompatRunpath must appear AFTER autoAddDriverRunpath.
        # See its documentation in ./setup-hooks/extension.nix.
        autoAddCudaCompatRunpath
      ]
      ++ nativeBuildInputs;

      propagatedBuildInputs = [ setupCudaHook ] ++ propagatedBuildInputs;

      buildInputs = [
        # autoPatchelfHook will search for a libstdc++ and we're giving it
        # one that is compatible with the rest of nixpkgs, even when
        # nvcc forces us to use an older gcc
        # NB: We don't actually know if this is the right thing to do
        # NOTE: Not all packages actually need this, but it's easier to just add it than create overrides for nearly all
        # of them.
        (lib.getLib stdenv.cc.cc)
      ]
      ++ buildInputs;

      # Picked up by autoPatchelf
      # Needed e.g. for libnvrtc to locate (dlopen) libnvrtc-builtins
      appendRunpaths = [ "$ORIGIN" ] ++ appendRunpaths;

      # NOTE: We don't need to check for dev or doc, because those outputs are handled by
      # the multiple-outputs setup hook.
      # NOTE: moveToOutput operates on all outputs:
      # https://github.com/NixOS/nixpkgs/blob/2920b6fc16a9ed5d51429e94238b28306ceda79e/pkgs/build-support/setup-hooks/multiple-outputs.sh#L105-L107
      # NOTE: installPhase is not moved into the builder hook because we do a lot of Nix templating.
      installPhase =
        let
          mkMoveToOutputCommand =
            output:
            let
              template = pattern: ''
                moveToOutput "${pattern}" "${"$" + output}"
              '';
              patterns = finalAttrs.passthru.outputToPatterns.${output} or [ ];
            in
            concatMapStringsSep "\n" template patterns;
        in
        # Pre-install hook
        ''
          runHook preInstall
        ''
        # Create the primary output, out, and move the other outputs into it.
        + ''
          mkdir -p "$out"
          nixLog "moving tree to output out"
          mv * "$out"
        ''
        # Move the outputs into their respective outputs.
        + ''
          ${concatMapStringsSep "\n" mkMoveToOutputCommand (tail finalAttrs.outputs)}
        ''
        # Post-install hook
        + ''
          runHook postInstall
        '';

      inherit doInstallCheck;
      inherit allowFHSReferences;

      passthru = passthru // {
        inherit redistName release;

        supportedReleases =
          passthru.supportedReleases
            # NOTE: `release` may be null, so we must use `lib.defaultTo`
            or (getSupportedReleases (lib.defaultTo { } finalAttrs.passthru.release));

        supportedNixSystems =
          passthru.supportedNixSystems or (pipe finalAttrs.passthru.supportedReleases [
            attrNames
            (concatMap getNixSystems)
            naturalSort
            unique
          ]);

        supportedRedistSystems =
          passthru.supportedRedistSystems or (naturalSort (attrNames finalAttrs.passthru.supportedReleases));

        # NOTE: Downstream may expand this to include other outputs, but they must remember to set the appropriate
        # outputNameVarFallbacks!
        inherit expectedOutputs;

        # Traversed in the order of the outputs speficied in outputs;
        # entries are skipped if they don't exist in outputs.
        inherit outputToPatterns;

        # Defines a list of fallbacks for each potential output.
        # The last fallback is the out output.
        # Taken and modified from:
        # https://github.com/NixOS/nixpkgs/blob/fe5e11faed6241aacf7220436088789287507494/pkgs/build-support/setup-hooks/multiple-outputs.sh#L45-L62
        inherit outputNameVarFallbacks;

        # brokenAssertions :: [Attrs]
        # Used by mkMetaBroken to set `meta.broken`.
        # Example: Broken on a specific version of CUDA or when a dependency has a specific version.
        # NOTE: Do not use this when a broken assertion means evaluation will fail! For example, if
        # a package is missing and is required for the build -- that should go in platformAssertions,
        # because attempts to access attributes on the package will cause evaluation errors.
        brokenAssertions = [
          {
            message = "CUDA support is enabled by config.cudaSupport";
            assertion = config.cudaSupport;
          }
          {
            message = "lib output precedes static output";
            assertion =
              let
                libIndex = findFirstIndex (x: x == "lib") null finalAttrs.outputs;
                staticIndex = findFirstIndex (x: x == "static") null finalAttrs.outputs;
              in
              libIndex == null || staticIndex == null || libIndex < staticIndex;
          }
          {
            # NOTE: We cannot (easily) check that all expected outputs have a corresponding outputNameVar attribute in
            # finalAttrs because of the presence of attributes which use the "output" prefix but are not outputNameVars
            # (e.g., outputChecks and outputName).
            message = "outputNameVarFallbacks is a super set of expectedOutputs";
            assertion =
              subtractLists (map mkOutputNameVar finalAttrs.passthru.expectedOutputs) (
                attrNames finalAttrs.passthru.outputNameVarFallbacks
              ) == [ ];
          }
          {
            message = "outputToPatterns is a super set of expectedOutputs";
            assertion =
              subtractLists finalAttrs.passthru.expectedOutputs (attrNames finalAttrs.passthru.outputToPatterns)
              == [ ];
          }
          {
            message = "propagatedBuildOutputs is a subset of outputs";
            assertion = subtractLists finalAttrs.outputs finalAttrs.propagatedBuildOutputs == [ ];
          }
        ]
        ++ brokenAssertions;

        # platformAssertions :: [Attrs]
        # Used by mkMetaBadPlatforms to set `meta.badPlatforms`.
        # Example: Broken on a specific system when some condition is met, like targeting Jetson or
        # a required package missing.
        # NOTE: Use this when a failed assertion means evaluation can fail!
        platformAssertions =
          let
            isSupportedRedistSystem = _redistSystemIsSupported hostRedistSystem finalAttrs.passthru.supportedRedistSystems;
          in
          [
            {
              message = "src is null if and only if hostRedistSystem is unsupported";
              assertion = (finalAttrs.src == null) == !isSupportedRedistSystem;
            }
            {
              message = "hostRedistSystem (${hostRedistSystem}) is supported (${builtins.toJSON finalAttrs.passthru.supportedRedistSystems})";
              assertion = isSupportedRedistSystem;
            }
          ]
          ++ platformAssertions;
      };

      meta = meta // {
        longDescription = meta.longDescription or "" + ''
          By downloading and using this package you accept the terms and conditions of the associated license(s).
        '';
        sourceProvenance = meta.sourceProvenance or [ sourceTypes.binaryNativeCode ];
        platforms = finalAttrs.passthru.supportedNixSystems;
        broken = _mkMetaBroken finalAttrs;
        badPlatforms = _mkMetaBadPlatforms finalAttrs;
        downloadPage =
          meta.downloadPage
            or "https://developer.download.nvidia.com/compute/${finalAttrs.passthru.redistName}/redist/${finalAttrs.pname}";
        # NOTE:
        #   Every redistributable should set its own license; since that's a lot of manual work, we default to
        #   nvidiaCudaRedist if the redistributable is from the CUDA redistributables and nvidiaCuda otherwise.
        #   Despite calling them "redistributable" and the download URL containing "redist", a number of these
        #   packages are not licensed such that redistribution is allowed.
        license =
          if meta ? license then
            lib.toList meta.license
          else if finalAttrs.passthru.redistName == "cuda" then
            [ licenses.nvidiaCudaRedist ]
          else
            [ licenses.nvidiaCuda ];
        teams = meta.teams or [ ] ++ [ teams.cuda ];
      };
    }
    # Setup the outputNameVar variables to gracefully handle missing outputs.
    # NOTE: We cannot use expectedOutputs from finalAttrs.passthru because we will infinitely recurse: presence of
    # attributes in finalAttrs cannot depend on finalAttrs.
    // foldl' (
      acc: output:
      let
        outputNameVar = mkOutputNameVar output;
      in
      acc
      // {
        ${outputNameVar} =
          findFirst (flip elem finalAttrs.outputs) "out"
            finalAttrs.passthru.outputNameVarFallbacks.${outputNameVar};
      }
    ) { } expectedOutputs;

  # Don't inherit any of stdenv.mkDerivation's arguments.
  inheritFunctionArgs = false;
}
