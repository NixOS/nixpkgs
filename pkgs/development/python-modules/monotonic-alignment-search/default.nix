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
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "eginhard";
    repo = "monotonic_alignment_search";
    rev = "refs/tags/v${version}";
    hash = "sha256-qBkJKED0KVArhzmhZo8UuWQ55XMMBgvKM3xOwiPVwKU=";
  };

  build-system = [
    setuptools
    cython
    numpy_2
  ];

  dependencies = [
    torch
  ];

  pytestFlagsArray = [ "tests" ];

  pythonImportsCheck = [ "monotonic_alignment_search" ];

  meta = {
    homepage = "https://github.com/eginhard/monotonic_alignment_search";
    description = "Monotonically align text and speech";
    changelog = "https://github.com/eginhard/monotonic_alignment_search/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jbgi ];
  };
}
