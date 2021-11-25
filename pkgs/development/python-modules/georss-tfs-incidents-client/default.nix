{ lib
, buildPythonPackage
, fetchFromGitHub
, georss-client
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "georss-tfs-incidents-client";
  version = "0.3";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-georss-tfs-incidents-client";
    rev = "v${version}";
    sha256 = "11nvwrjzax4yy6aj971yym05yyizwfafy4ccsyy1qpwbs6dwbw7m";
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
