{
  lib,
  stdenv,
  buildPythonPackage,
  cudaPackages,
  writeShellApplication,

  # build-system
  setuptools,

  # dependencies
  numpy,

  # optional-dependencies
  onnx,
  onnx-graphsurgeon,
  onnxruntime,
  tensorrt,

  # tests
  pytestCheckHook,
  torch,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "polygraphy";
  # `__version__` of polygraphy, which is versioned independently of TensorRT. A cudaPackages.tensorrt update that changes
  # `__version__` breaks this package (pythonMetadataCheckHook) until passthru.updateScript is run, so run it in the same
  # change. It also fails where cudaPackages uses an older TensorRT, such as with Jetson capabilities.
  version = "0.53.6";
  pyproject = true;
  __structuredAttrs = true;

  # cudaPackages.tensorrt-samples's source, the TensorRT OSS release of cudaPackages.tensorrt, so that Nixpkgs has one
  # TensorRT OSS tree
  inherit (cudaPackages.tensorrt-samples) src;

  sourceRoot = "${finalAttrs.src.name}/tools/Polygraphy";

  patches = [
    # The TensorRT 11.3 OSS release removed setup.py but left out the pyproject.toml that replaced it
    # (https://github.com/NVIDIA/TensorRT/issues/4894). This adds one that reproduces the metadata of the polygraphy
    # wheel on PyPI, from https://github.com/NVIDIA/TensorRT/pull/4896 (open, a draft), so it is vendored: the output of
    # `git format-patch --relative=tools/Polygraphy` for that PR's commit 08081862400247ed78c45b9ca901f1a57f1be309,
    # whose parent is the v11.4 tag. Once the PR merges, fetch its merge commit with fetchpatch2
    # (`relative = "tools/Polygraphy"`) instead; drop the patch once a TensorRT release includes the file.
    ./add-missing-pyproject-toml.patch
  ];

  build-system = [ setuptools ];

  # Upstream declares no dependencies: every module is imported lazily, when a backend needs it. NumPy is needed by all
  # of the backends and comparators.
  dependencies = [ numpy ];

  # Upstream declares no extras; these group the lazily-imported dependencies of the backends.
  optional-dependencies = {
    onnx = [
      onnx
      onnx-graphsurgeon
    ];
    onnxruntime = [ onnxruntime ];
    tensorrt = [ tensorrt ];
  };

  pythonImportsCheck = [
    "polygraphy"
    "polygraphy.tools"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    torch # the comparator tests also run on torch tensors
    writableTmpDirAsHomeHook
  ];

  # Enables the checks of internal invariants that some tests exercise, as upstream's Makefile does.
  env.POLYGRAPHY_INTERNAL_CORRECTNESS_CHECKS = "1";

  # Most of the test modules (and tests/tools/conftest.py) import tensorrt, which is unfree and needs a GPU for most
  # tests; these modules don't.
  enabledTestPaths = [
    "tests/backend/base/test_loader.py"
    "tests/common/test_interface.py"
    "tests/common/test_struct.py"
    "tests/comparator/test_compare.py"
    "tests/comparator/test_postprocess.py"
    "tests/func/test_func.py"
    "tests/logger/test_logger.py"
    "tests/mod/test_exporter.py"
    "tests/mod/test_util.py"
    "tests/test_deprecated_aliases.py"
  ];

  disabledTestPaths = lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # aarch64-linux fails cpuinfo test, because /sys/devices/system/cpu/ does not exist in the sandbox:
    # RuntimeError: Failed to initialize cpuinfo!
    "comparator/test_compare.py::TestSimpleCompareFunc::test_comparison[values07-values17-dtype7-5-expected_max_reldiff7-torch]"
    "comparator/test_compare.py::TestSimpleCompareFunc::test_comparison[values08-values18-dtype8-1-4503599627370496.0-torch]"
    "comparator/test_compare.py::TestSimpleCompareFunc::test_quantile[values00-values10-dtype0-0.5-1.5-0.75-torch]"
    "comparator/test_compare.py::TestSimpleCompareFunc::test_quantile[values01-values11-dtype1-0.75-1.9-0.95-torch]"
    "comparator/test_compare.py::TestSimpleCompareFunc::test_quantile[values02-values12-dtype2-0.5-0.0625-0.625-torch]"
    "comparator/test_postprocess.py::TestTopK::test_top_k_half[<lambda>]"
  ];

  # Sets `version` to the `__version__` of polygraphy in the source, which cudaPackages.tensorrt updates move. (The default,
  # nix-update, would set `version` to the TensorRT release.) The file is an argument so that
  # maintainers/scripts/update.py can redirect it to its worktree.
  passthru.updateScript = [
    (lib.getExe (writeShellApplication {
      name = "polygraphy-updater";
      text = ''
        init=${finalAttrs.src}/tools/Polygraphy/polygraphy/__init__.py
        version="$(sed -nE 's/^__version__ = "(.+)"$/\1/p' "$init")"
        if [[ -z $version ]]; then
          echo "error: no __version__ in $init" >&2
          exit 1
        fi
        sed -i "s|^  version = \"${finalAttrs.version}\";$|  version = \"$version\";|" "$1"
        if ! grep -q "^  version = \"$version\";$" "$1"; then
          echo "error: could not set version = \"$version\" in $1" >&2
          exit 1
        fi
      '';
    }))
    (toString ./default.nix)
  ];

  meta = {
    description = "Deep learning inference prototyping and debugging toolkit";
    homepage = "https://github.com/NVIDIA/TensorRT/tree/main/tools/Polygraphy";
    changelog = "https://github.com/NVIDIA/TensorRT/blob/${finalAttrs.src.tag}/tools/Polygraphy/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ connorbaker ];
    teams = [ lib.teams.cuda ];
    mainProgram = "polygraphy";
  };
})
