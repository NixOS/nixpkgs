{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # tests
  pytest-mock,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "cuda-pathfinder";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "cuda-python";
    tag = "cuda-pathfinder-v${finalAttrs.version}";
    hash = "sha256-Bsou6vLyMBNbVMPT4vtnWpoi05lXG6pjhuee6Hg/Mm8=";
  };

  sourceRoot = "${finalAttrs.src.name}/cuda_pathfinder";

  build-system = [
    setuptools
    setuptools-scm
  ];

  pythonImportsCheck = [
    "cuda"
    "cuda.pathfinder"
  ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
  ];

  meta = {
    description = "one-stop solution for locating CUDA components";
    homepage = "https://github.com/NVIDIA/cuda-python/tree/main/cuda_pathfinder";
    changelog = "https://nvidia.github.io/cuda-python/cuda-pathfinder/${finalAttrs.version}/release/${finalAttrs.version}-notes.html";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    platforms = lib.platforms.linux;
  };
})
