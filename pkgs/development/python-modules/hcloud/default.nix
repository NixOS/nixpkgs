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
  version = "1.18.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oh2UDN6PDB/RCgWBsGGOuECm9ZJAT6r9tgcBAfRSX/Y=";
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
