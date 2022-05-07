{ lib, buildPythonPackage, fetchFromGitHub, numpy, treelog, stringly, pytestCheckHook, pythonOlder }:

buildPythonPackage rec {
  pname = "nutils";
  version = "7.0";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "evalf";
    repo = "nutils";
    rev = "refs/tags/v${version}";
    hash = "sha256-V7lSMhwzc9+36uXMCy5uF241XwJ62Pdf59RUulOt4i8=";
  };

  pythonImportsCheck = [ "nutils" ];

  propagatedBuildInputs = [
    numpy
    treelog
    stringly
  ];

  checkInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # AttributeError: type object 'setup' has no attribute '__code__'
    "tests/test_cli.py"
  ];


  meta = with lib; {
    description = "Numerical Utilities for Finite Element Analysis";
    homepage = "https://www.nutils.org/";
    license = licenses.mit;
    maintainers = [ maintainers.Scriptkiddi ];
  };
}
