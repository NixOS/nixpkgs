{ lib
, buildPythonPackage
, fetchFromGitHub
, cryptography
, python-dateutil
, requests
, requests-toolbelt
, requests-unixsocket
, ws4py
, ddt
, mock-services
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pylxd";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "lxc";
    repo = "pylxd";
    rev = version;
    sha256 = "sha256-eDRCJYjmBndMnSNuS6HD/2p/KhzqJq2qPAzMk7kC5UM=";
  };

  propagatedBuildInputs = [
    cryptography
    python-dateutil
    requests
    requests-toolbelt
    requests-unixsocket
    ws4py
  ];

  checkInputs = [
    ddt
    mock-services
    pytestCheckHook
  ];

  disabledTestPaths = [
    "integration"
    "migration"
  ];

  pythonImportsCheck = [ "pylxd" ];

  meta = with lib; {
    description = "A Python library for interacting with the LXD REST API";
    homepage = "https://pylxd.readthedocs.io/en/latest/";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
