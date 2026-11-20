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
  version = "1.8.3";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "cuda-python";
    tag = "cuda-pathfinder-v${finalAttrs.version}";
    # GitHub expands the export-subst'd .git_archival.txt when generating the tarball. Its ref-names line lists every
    # branch pointing at the tagged commit, so the hash changes when e.g. a release branch moves on, even though the tag
    # did not. Keep only the tag, which setuptools-scm still resolves to the right version.
    postFetch = ''
      sed -i 's/^ref-names: .*$/ref-names: tag: cuda-pathfinder-v${finalAttrs.version}/' "$out/.git_archival.txt"
      grep -qx 'ref-names: tag: cuda-pathfinder-v${finalAttrs.version}' "$out/.git_archival.txt"
    '';
    hash = "sha256-QpfjtVZpNAa8R5ZyGJO7W0PGorWE/wnpUKCEyBQbYI8=";
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
