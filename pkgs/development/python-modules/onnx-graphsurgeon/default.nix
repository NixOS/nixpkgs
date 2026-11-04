{
  lib,
  buildPythonPackage,
  cudaPackages,
  writeShellApplication,

  # build-system
  setuptools,

  # dependencies
  ml-dtypes,
  numpy,
  onnx,

  # tests
  onnxruntime,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "onnx-graphsurgeon";
  # `__version__` of onnx_graphsurgeon, which is versioned independently of TensorRT. A cudaPackages.tensorrt update that
  # changes `__version__` breaks this package (pythonMetadataCheckHook) until passthru.updateScript is run, so run it in
  # the same change. It also fails where cudaPackages uses an older TensorRT, such as with Jetson capabilities.
  # 0.6.2 is only on GitHub; PyPI's latest is 0.6.1 (https://github.com/NVIDIA/TensorRT/issues/4895).
  version = "0.6.2";
  pyproject = true;
  __structuredAttrs = true;

  # cudaPackages.tensorrt-samples's source, the TensorRT OSS release of cudaPackages.tensorrt, so that Nixpkgs has one
  # TensorRT OSS tree
  inherit (cudaPackages.tensorrt-samples) src;

  sourceRoot = "${finalAttrs.src.name}/tools/onnx-graphsurgeon";

  build-system = [ setuptools ];

  dependencies = [
    ml-dtypes
    numpy
    onnx
  ];

  pythonImportsCheck = [ "onnx_graphsurgeon" ];

  nativeCheckInputs = [
    onnxruntime
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Runs the example scripts, some of which download models
    "tests/test_examples.py"
  ];

  # Sets `version` to the `__version__` of onnx_graphsurgeon in the source, which cudaPackages.tensorrt updates move. (The
  # default, nix-update, would set `version` to the TensorRT release.) The file is an argument so that
  # maintainers/scripts/update.py can redirect it to its worktree.
  passthru.updateScript = [
    (lib.getExe (writeShellApplication {
      name = "onnx-graphsurgeon-updater";
      text = ''
        init=${finalAttrs.src}/tools/onnx-graphsurgeon/onnx_graphsurgeon/__init__.py
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
    description = "Generate, modify and transform ONNX graphs";
    homepage = "https://github.com/NVIDIA/TensorRT/tree/main/tools/onnx-graphsurgeon";
    changelog = "https://github.com/NVIDIA/TensorRT/blob/${finalAttrs.src.tag}/tools/onnx-graphsurgeon/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ connorbaker ];
    teams = [ lib.teams.cuda ];
  };
})
