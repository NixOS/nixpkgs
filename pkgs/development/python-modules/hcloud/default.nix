{ lib
, buildPythonPackage
, fetchPypi
, future
, mock
, pytestCheckHook
, python-dateutil
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "hcloud";
  version = "1.17.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+BQuBDi+J3xvod3uE67NXaFStIxt7H/Ulw3vG13CGeI=";
  };

  propagatedBuildInputs = [
    future
    requests
    python-dateutil
  ];

  checkInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "hcloud"
  ];

  meta = with lib; {
    description = "Library for the Hetzner Cloud API";
    homepage = "https://github.com/hetznercloud/hcloud-python";
    license = licenses.mit;
    maintainers = with maintainers; [ liff ];
  };
}
