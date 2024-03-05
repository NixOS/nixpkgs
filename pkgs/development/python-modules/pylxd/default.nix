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
  version = "2.3.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "lxc";
    repo = "pylxd";
    rev = "refs/tags/${version}";
    hash = "sha256-Q4GMz7HFpJNPYlYgLhE0a7mVCwNpdbw4XVcUGQ2gUJ0=";
  };

  propagatedBuildInputs = [
    cryptography
    python-dateutil
    requests
    requests-toolbelt
    requests-unixsocket
    ws4py
  ];

  nativeCheckInputs = [
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
