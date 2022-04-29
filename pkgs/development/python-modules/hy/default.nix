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
  version = "1.0a3";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "hylang";
    repo = pname;
    rev = version;
    sha256 = "1dqw24rvsps2nab1pbjjm1c81vrs34r4kkk691h3xdyxnv9hb84b";
  };

  propagatedBuildInputs = [
    colorama
    funcparserlib
    rply
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
    maintainers = with maintainers; [ fab ];
  };
}
