{ lib
, buildPythonPackage
, fetchFromGitHub
, paramiko
, selectors2
, lxml
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "ncclient";
  version = "0.6.12";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "1sjvqaxb54nmqljiw5bg1423msa9rg015wiix9fsm6djk3wpklmk";
  };

  propagatedBuildInputs = [
    paramiko
    lxml
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "ncclient" ];

  meta = with lib; {
    homepage = "https://github.com/ncclient/ncclient";
    description = "Python library for NETCONF clients";
    license = licenses.asl20;
    maintainers = with maintainers; [ xnaveira ];
  };
}
