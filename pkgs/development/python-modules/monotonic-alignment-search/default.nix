{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  cython,
  numpy_2,

  # dependencies
  torch,
}:

buildPythonPackage rec {
  pname = "monotonic-alignment-search";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "eginhard";
    repo = "monotonic_alignment_search";
    tag = "v${version}";
    hash = "sha256-N714DfLyrdhhm2yWlMzUVZkQ5Ys2aOmtEcxACGM665Y=";
  };

  build-system = [
    setuptools
    cython
    numpy_2
  ];

  dependencies = [
    torch
  ];

  enabledTestPaths = [ "tests" ];

  pythonImportsCheck = [ "monotonic_alignment_search" ];

  meta = {
    homepage = "https://github.com/eginhard/monotonic_alignment_search";
    description = "Monotonically align text and speech";
    changelog = "https://github.com/eginhard/monotonic_alignment_search/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jbgi ];
  };
}
