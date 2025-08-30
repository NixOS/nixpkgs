# NOTE: All fixups must be at least binary functions to avoid callPackage adding override attributes.
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
  flags,
  lib,
  markForCudatoolkitRootHook,
  setupCudaHook,
  stdenv,
}:
let
  inherit (_cuda.lib) _mkMetaBadPlatforms _mkMetaBroken _redistSystemIsSupported;
  inherit (backendStdenv) hostRedistSystem;
  inherit (lib)
    licenses
    sourceTypes
    teams
    ;
  inherit (lib.asserts) assertMsg;
  inherit (lib.attrsets) attrNames;
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

  # Order is important here so we use a list.
  # NOTE: Moved out of the attribute set overlay so we can use it to add top-level attributes.
  expectedOutputs = [
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
  ];
in
finalAttrs: prevAttrs:
let
  inherit (finalAttrs.passthru) redistBuilderArg;
  hasOutput = flip elem finalAttrs.outputs;
in
{
  __structuredAttrs = true;
  strictDeps = true;

  # Name should be prefixed by cudaNamePrefix to create more descriptive path names.
  name = "${cudaNamePrefix}-${finalAttrs.pname}-${finalAttrs.version}";

  # NOTE: Even though there's no actual buildPhase going on here, the derivations of the
  # redistributables are sensitive to the compiler flags provided to stdenv. The patchelf package
  # is sensitive to the compiler flags provided to stdenv, and we depend on it. As such, we are
  # also sensitive to the compiler flags provided to stdenv.
  pname = redistBuilderArg.packageName;
  version = redistBuilderArg.releaseVersion;

  # We should only have the output `out` when `src` is null.
  # lists.intersectLists iterates over the second list, checking if the elements are in the first list.
  # As such, the order of the output is dictated by the order of the second list.
  outputs =
    if finalAttrs.src == null then
      [ "out" ]
    else
      intersectLists redistBuilderArg.outputs finalAttrs.passthru.expectedOutputs;

  # Enforcing a size limitation on the out output lets us detect if we forgot to
  # move something into the bin or lib output.
  # This should be overridden by packages where we must keep more in `out`.
  # TODO(@connorbaker): This doesn't seem to be working, or at least, isn't triggered when using `--rebuild`.
  outputChecks.out.maxSize = 128 * 1024; # 128 KiB

  # NOTE: Because the `dev` output is special in Nixpkgs -- make-derivation.nix uses it as the default if
  # it is present -- we must ensure that it brings in the expected dependencies. For us, this means that `dev`
  # should include `bin`, `include`, and `lib` -- `static` is notably absent because it is quite large.
  # We do not include `stubs`, as a number of packages contain stubs for libraries they already ship with!
  # Only a few, like cuda_cudart, actually provide stubs for libraries we're missing.
  # As such, these packages should override propagatedBuildOutputs to add `stubs`.
  propagatedBuildOutputs = intersectLists [
    "bin"
    "include"
    "lib"
  ] finalAttrs.outputs;

  # src :: null | Derivation
  src = redistBuilderArg.releaseSource;

  # Required for the hook.
  inherit cudaMajorMinorVersion cudaMajorVersion;

  # We do need some other phases, like configurePhase, so the multiple-output setup hook works.
  dontBuild = true;

  nativeBuildInputs =
    prevAttrs.nativeBuildInputs or [ ]
    ++ [
      ./redistBuilderHook.bash
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
    ++ lib.optionals (finalAttrs.pname != "cuda_compat" && flags.isJetsonBuild) [
      # autoAddCudaCompatRunpath must appear AFTER autoAddDriverRunpath.
      # See its documentation in ./setup-hooks/extension.nix.
      autoAddCudaCompatRunpath
    ];

  propagatedBuildInputs = prevAttrs.propagatedBuildInputs or [ ] ++ [ setupCudaHook ];

  buildInputs = prevAttrs.buildInputs or [ ] ++ [
    # autoPatchelfHook will search for a libstdc++ and we're giving it
    # one that is compatible with the rest of nixpkgs, even when
    # nvcc forces us to use an older gcc
    # NB: We don't actually know if this is the right thing to do
    # NOTE: Not all packages actually need this, but it's easier to just add it than create overrides for nearly all
    # of them.
    (lib.getLib stdenv.cc.cc)
  ];

  # Picked up by autoPatchelf
  # Needed e.g. for libnvrtc to locate (dlopen) libnvrtc-builtins
  appendRunpaths = prevAttrs.appendRunpaths or [ ] ++ [ "$ORIGIN" ];

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

  doInstallCheck = true;
  allowFHSReferences = false;

  passthru = prevAttrs.passthru or { } // {
    redistBuilderArg = {
      # The name of the redistributable to which this package belongs.
      redistName = builtins.throw "redist-builder: ${finalAttrs.name} did not set passthru.redistBuilderArg.redistName";

      # The full package name, for use in meta.description
      # e.g., "CXX Core Compute Libraries"
      releaseName = builtins.throw "redist-builder: ${finalAttrs.name} did not set passthru.redistBuilderArg.releaseName";

      # The package version
      # e.g., "12.2.140"
      releaseVersion = builtins.throw "redist-builder: ${finalAttrs.name} did not set passthru.redistBuilderArg.releaseVersion";

      # The path to the license, or null
      # e.g., "cuda_cccl/LICENSE.txt"
      licensePath = builtins.throw "redist-builder: ${finalAttrs.name} did not set passthru.redistBuilderArg.licensePath";

      # The short name of the package
      # e.g., "cuda_cccl"
      packageName = builtins.throw "redist-builder: ${finalAttrs.name} did not set passthru.redistBuilderArg.packageName";

      # Package source, or null
      releaseSource = builtins.throw "redist-builder: ${finalAttrs.name} did not set passthru.redistBuilderArg.releaseSource";

      # The outputs provided by this package.
      outputs = builtins.throw "redist-builder: ${finalAttrs.name} did not set passthru.redistBuilderArg.outputs";

      # TODO(@connorbaker): Document these
      supportedRedistSystems = builtins.throw "redist-builder: ${finalAttrs.name} did not set passthru.redistBuilderArg.supportedRedistSystems";
      supportedNixSystems = builtins.throw "redist-builder: ${finalAttrs.name} did not set passthru.redistBuilderArg.supportedNixSystems";
    }
    // prevAttrs.passthru.redistBuilderArg or { };

    # NOTE: Downstream may expand this to include other outputs, but they must remember to set the appropriate
    # outputNameVarFallbacks!
    inherit expectedOutputs;

    # Traversed in the order of the outputs speficied in outputs;
    # entries are skipped if they don't exist in outputs.
    outputToPatterns = {
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
    };

    # Defines a list of fallbacks for each potential output.
    # The last fallback is the out output.
    # Taken and modified from:
    # https://github.com/NixOS/nixpkgs/blob/fe5e11faed6241aacf7220436088789287507494/pkgs/build-support/setup-hooks/multiple-outputs.sh#L45-L62
    outputNameVarFallbacks = {
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
    };

    # brokenAssertions :: [Attrs]
    # Used by mkMetaBroken to set `meta.broken`.
    # Example: Broken on a specific version of CUDA or when a dependency has a specific version.
    # NOTE: Do not use this when a broken assertion means evaluation will fail! For example, if
    # a package is missing and is required for the build -- that should go in platformAssertions,
    # because attempts to access attributes on the package will cause evaluation errors.
    brokenAssertions = prevAttrs.passthru.brokenAssertions or [ ] ++ [
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
    ];

    # platformAssertions :: [Attrs]
    # Used by mkMetaBadPlatforms to set `meta.badPlatforms`.
    # Example: Broken on a specific system when some condition is met, like targeting Jetson or
    # a required package missing.
    # NOTE: Use this when a failed assertion means evaluation can fail!
    platformAssertions =
      let
        isSupportedRedistSystem = _redistSystemIsSupported hostRedistSystem redistBuilderArg.supportedRedistSystems;
      in
      prevAttrs.passthru.platformAssertions or [ ]
      ++ [
        {
          message = "src is null if and only if hostRedistSystem is unsupported";
          assertion = (finalAttrs.src == null) == !isSupportedRedistSystem;
        }
        {
          message = "hostRedistSystem (${hostRedistSystem}) is supported (${builtins.toJSON redistBuilderArg.supportedRedistSystems})";
          assertion = isSupportedRedistSystem;
        }
      ];
  };

  meta = prevAttrs.meta or { } // {
    longDescription = ''
      By downloading and using this package you accept the terms and conditions of the associated license(s).
    '';
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
    platforms = redistBuilderArg.supportedNixSystems;
    broken = _mkMetaBroken (!(config.inHydra or false)) finalAttrs;
    badPlatforms = _mkMetaBadPlatforms (!(config.inHydra or false)) finalAttrs;
    license = licenses.nvidiaCudaRedist // {
      url =
        let
          licensePath =
            if redistBuilderArg.licensePath != null then
              redistBuilderArg.licensePath
            else
              "${redistBuilderArg.packageName}/LICENSE.txt";
        in
        "https://developer.download.nvidia.com/compute/${redistBuilderArg.redistName}/redist/${licensePath}";
    };
    teams = [ teams.cuda ];
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
      findFirst hasOutput "out"
        finalAttrs.passthru.outputNameVarFallbacks.${outputNameVar};
  }
) { } expectedOutputs
