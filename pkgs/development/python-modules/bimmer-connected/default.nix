{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pbr
, httpx
, pycryptodome
, pyjwt
, pytestCheckHook
, respx
, time-machine
}:

buildPythonPackage rec {
  pname = "bimmer-connected";
  version = "0.9.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "bimmerconnected";
    repo = "bimmer_connected";
    rev = version;
    hash = "sha256-ZL/1qZ/VTKQ98/THfFTjJilJgkxMV7dwiJiMOu6iJ8o=";
  };

  nativeBuildInputs = [
    pbr
  ];

  PBR_VERSION = version;

  propagatedBuildInputs = [
    httpx
    pycryptodome
    pyjwt
  ];

  checkInputs = [
    pytestCheckHook
    respx
    time-machine
  ];

  meta = with lib; {
    description = "Library to read data from the BMW Connected Drive portal";
    homepage = "https://github.com/bimmerconnected/bimmer_connected";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
