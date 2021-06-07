{ lib
, buildPythonPackage
, fetchFromGitHub
, georss-client
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "georss-tfs-incidents-client";
  version = "0.2";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-georss-tfs-incidents-client";
    rev = "v${version}";
    sha256 = "10qscn7kncb7h0b8mjykkf5kmm3ga9l8gss4acb888iaigcjgavf";
  };

  propagatedBuildInputs = [
    georss-client
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "georss_tfs_incidents_client" ];

  meta = with lib; {
    description = "Python library for accessing Tasmania Fire Service Incidents feed";
    homepage = "https://github.com/exxamalte/python-georss-tfs-incidents-client";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
