{ lib, python3Packages, fetchPypi }:

python3Packages.buildPythonApplication rec {
  pname   = "lesscpy";
  version = "0.15.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-EEXRepj2iGRsp1jf8lTm6cA3RWSOBRoIGwOVw7d8gkw=";
  };

  checkInputs = with python3Packages; [ pytestCheckHook ];
  pythonImportsCheck = [ "lesscpy" ];
  propagatedBuildInputs = with python3Packages; [ ply six ];

  nativeCheckInputs = with python3Packages; [
    tox
    nose
    flake8
  ];

  meta = with lib; {
    description = "Python LESS Compiler";
    mainProgram = "lesscpy";
    homepage    = "https://github.com/lesscpy/lesscpy";
    license     = licenses.mit;
    maintainers = with maintainers; [ s1341 WhiteBlackGoose ];
  };
}
