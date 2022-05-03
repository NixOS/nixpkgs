{ lib
, astor
, buildPythonPackage
, colorama
, fetchFromGitHub
, funcparserlib
, pytestCheckHook
, pythonOlder
, rply
}:

buildPythonPackage rec {
  pname = "hy";
  version = "1.0a4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "hylang";
    repo = pname;
    rev = version;
    sha256 = "sha256-MBzp3jqBg/kH233wcgYYHc+Yg9GuOaBsXIfjFDihD1E=";
  };

  propagatedBuildInputs = [
    colorama
    funcparserlib
    rply # TODO: remove on the next release
  ] ++ lib.optionals (pythonOlder "3.9") [
    astor
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # Don't test the binary
    "test_bin_hy"
    "test_hystartup"
    "est_hy2py_import"
  ];

  pythonImportsCheck = [ "hy" ];

  meta = with lib; {
    description = "Python to/from Lisp layer";
    homepage = "https://github.com/hylang/hy";
    license = licenses.mit;
    maintainers = with maintainers; [ fab thiagokokada ];
  };
}
