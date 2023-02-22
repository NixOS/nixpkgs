{ lib
, aiofile
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
  version = "0.12.3";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "bimmerconnected";
    repo = "bimmer_connected";
    rev = "refs/tags/${version}";
    hash = "sha256-LkA92pc5lXScB/+O+tdh+Vi/m9IdhNehVeGgg52lNm4=";
  };

  nativeBuildInputs = [
    pbr
  ];

  PBR_VERSION = version;

  propagatedBuildInputs = [
    aiofile
    httpx
    pycryptodome
    pyjwt
  ];

  nativeCheckInputs = [
    pytestCheckHook
    respx
    time-machine
  ];

  pythonImportsCheck = [
    "bimmer_connected"
  ];

  meta = with lib; {
    description = "Library to read data from the BMW Connected Drive portal";
    homepage = "https://github.com/bimmerconnected/bimmer_connected";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
