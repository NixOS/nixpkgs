{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "parsy";
  version = "1.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    repo = "parsy";
    owner = "python-parsy";
    rev = "v${version}";
    sha256 = "sha256-FislrLb+u4T5m/eEER7kazZHJKEwPHe+Vg/YDJp4PyM=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "parsy"
  ];

  meta = with lib; {
    homepage = "https://github.com/python-parsy/parsy";
    description = "Easy-to-use parser combinators, for parsing in pure Python";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ milibopp ];
  };
}
