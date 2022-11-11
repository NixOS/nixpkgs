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
  version = "0.6.13";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-NrilXB1NFcqNCGrwshhuLdhQoeHJ12PSp4MBScT9kYc=";
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
