{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aioblescan";
  version = "0.2.13";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "frawau";
    repo = pname;
    rev = version;
    hash = "sha256-n1FiBsuVpVJrIq6+kuMNugpEaUOFQ/Gk/QU7Hry4YrU=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "aioblescan"
  ];

  meta = with lib; {
    description = "Library to listen for BLE advertized packets";
    homepage = "https://github.com/frawau/aioblescan";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
