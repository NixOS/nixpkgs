{
  lib,
  buildPythonPackage,
  fetchPypi,
  fonttools,
  pyclipper,
  defcon,
  fontpens,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "booleanoperations";
  version = "0.9.0";
  pyproject = true;

  src = fetchPypi {
    pname = "booleanOperations";
    inherit version;
    hash = "sha256-jPqCHDKtN0+hINay4LRE6+rFfJHmYxUoZF+hmsKigbg=";
    extension = "zip";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    fonttools
    pyclipper
  ];

  pythonImportsCheck = [ "booleanOperations" ];

  nativeCheckInputs = [
    defcon
    fontpens
    pytestCheckHook
  ];

  disabledTests = [
    # started failing with fonttools update from 4.55.3 -> 4.56.0
    "test_QTail_reversed_difference"
    "test_QTail_reversed_intersection"
    "test_QTail_reversed_union"
    "test_QTail_reversed_xor"
    "test_Q_difference"
    "test_Q_intersection"
    "test_Q_union"
    "test_Q_xor"
  ];

  meta = {
    description = "Boolean operations on paths";
    homepage = "https://github.com/typemytype/booleanOperations";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.sternenseemann ];
  };
}
