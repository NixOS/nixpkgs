{
  lib,
  black,
  buildPythonPackage,
  fetchPypi,
  hypothesis,
  lark,
  libcst,
  parso,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-xdist,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "hypothesmith";
  version = "0.3.3";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lsFIAtbI6F2JdSZBdoeNtUso0u2SH9v+3C5rjOPIFxY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    hypothesis
    lark
    libcst
  ];

  nativeCheckInputs = [
    black
    parso
    pytestCheckHook
    pytest-cov-stub
    pytest-xdist
  ];

  disabledTests = [
    # super slow
    "test_source_code_from_libcst_node_type"
    # https://github.com/Zac-HD/hypothesmith/issues/38
    "test_black_autoformatter_from_grammar"
  ];

  pythonImportsCheck = [ "hypothesmith" ];

  meta = with lib; {
    description = "Hypothesis strategies for generating Python programs, something like CSmith";
    homepage = "https://github.com/Zac-HD/hypothesmith";
    changelog = "https://github.com/Zac-HD/hypothesmith/blob/master/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = [ ];
  };
}
