{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, hatchling
, hatch-vcs
, git
, astor
, interface-meta
, numpy
, pandas
, scipy
, sympy
, wrapt
, typing-extensions
}:

buildPythonPackage rec {
  pname = "formulaic";
  version = "1.0.1";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "matthewwardrop";
    repo = "formulaic";
    rev = "refs/tags/v${version}";
    hash = "sha256-qivWv1LtFkW55tVKD/Zjd8Q5gVbxhDpZ0inkV6NR7bA=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    hatchling
    hatch-vcs
  ];

  propagatedBuildInputs = [
    astor
    numpy
    pandas
    scipy
    wrapt
    typing-extensions
    interface-meta
    sympy
  ];

  pythonImportsCheck = [ "formulaic" ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    "tests/transforms/test_poly.py"
  ];

  meta = {
    homepage = "https://matthewwardrop.github.io/formulaic/";
    description = "High-performance implementation of Wilkinson formulas for";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ swflint ];
  };
}
