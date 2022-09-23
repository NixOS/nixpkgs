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
  version = "0.10.3";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "bimmerconnected";
    repo = "bimmer_connected";
    rev = "refs/tags/${version}";
    hash = "sha256-3jCxncR7bD0DDAH6vt28eBal9cVI9liLbBCX0IJ2bQ8=";
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
