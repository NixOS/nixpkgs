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
  lib,
  manifests,
  markForCudatoolkitRootHook,
  setupCudaHook,
  srcOnly,
  stdenv,
  stdenvNoCC,
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
  inherit (_cuda.lib)
    _hasProblemKind
    _mkMetaProblems
    _mkMetaBadPlatforms
    _redistSystemIsSupported
    ;
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
          stdenv = stdenvNoCC;
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
      };

      meta = meta // {
        longDescription = meta.longDescription or "" + ''
          By downloading and using this package you accept the terms and conditions of the associated license(s).
        '';
        sourceProvenance = meta.sourceProvenance or [ sourceTypes.binaryNativeCode ];
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

        broken = meta.broken or false || _hasProblemKind "broken" finalAttrs;
        platforms =
          meta.platforms or (pipe finalAttrs.passthru.supportedReleases [
            attrNames
            (concatMap getNixSystems)
            naturalSort
            unique
          ]);
        badPlatforms = _mkMetaBadPlatforms finalAttrs;

        problems =
          let
            isSupportedRedistSystem = _redistSystemIsSupported hostRedistSystem finalAttrs.passthru.supportedRedistSystems;
          in
          meta.problems or [ ]
          ++ _mkMetaProblems [
            {
              kind = "unsupported";
              message = ''
                CUDA without global `config.cudaSupport` is unsafe and unsupported.
                Cf. NixOS 25.11 Release Notes.

                a) Use `import <nixpkgs> { config.cudaSupport = true; }`.
                b) For `nixos-rebuild`, set
                  { nixpkgs.config.cudaSupport = true; }
                in `configuration.nix`.
                c) For `nix-env`, `nix-build`, `nix-shell` or any other Nix command you can add
                  { cudaSupport = true; }
                to ~/.config/nixpkgs/config.nix.
              '';
              assertion = config.cudaSupport;
            }
            {
              kind = "unsupported";
              message = "src is null if and only if hostRedistSystem is unsupported";
              assertion = (finalAttrs.src == null) == !isSupportedRedistSystem;
            }
            {
              kind = "unsupported";
              message = "hostRedistSystem (${hostRedistSystem}) is supported (${builtins.toJSON finalAttrs.passthru.supportedRedistSystems})";
              assertion = isSupportedRedistSystem;
            }

            {
              kind = "broken";
              message = "lib output precedes static output";
              assertion =
                let
                  libIndex = findFirstIndex (x: x == "lib") null finalAttrs.outputs;
                  staticIndex = findFirstIndex (x: x == "static") null finalAttrs.outputs;
                in
                libIndex == null || staticIndex == null || libIndex < staticIndex;
            }
            {
              kind = "broken";
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
              kind = "broken";
              message = "outputToPatterns is a super set of expectedOutputs";
              assertion =
                subtractLists finalAttrs.passthru.expectedOutputs (attrNames finalAttrs.passthru.outputToPatterns)
                == [ ];
            }
            {
              kind = "broken";
              message = "propagatedBuildOutputs is a subset of outputs";
              assertion = subtractLists finalAttrs.outputs finalAttrs.propagatedBuildOutputs == [ ];
            }
          ];
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
