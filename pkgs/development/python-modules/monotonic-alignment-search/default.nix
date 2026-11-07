{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  cython,
  numpy,

  # dependencies
  torch,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "monotonic-alignment-search";
  version = "0.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "eginhard";
    repo = "monotonic_alignment_search";
    tag = "v${version}";
    hash = "sha256-/a/hQW3LjpvbgjK/Z+nDeYkhEoIvdf1tRHesNIL1FWA=";
  };

  build-system = [
    setuptools
    cython
    numpy
  ];

  dependencies = [
    numpy
    torch
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "monotonic_alignment_search" ];

  meta = {
    homepage = "https://github.com/eginhard/monotonic_alignment_search";
    description = "Monotonically align text and speech";
    changelog = "https://github.com/eginhard/monotonic_alignment_search/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jbgi ];
  };
}
