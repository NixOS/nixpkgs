{ lib
, aiofile
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pbr
, httpx
, pycryptodome
, pyjwt
, pytest-asyncio
, pytestCheckHook
, python
, respx
, time-machine
, tzdata
}:

buildPythonPackage rec {
  pname = "bimmer-connected";
  version = "0.14.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "bimmerconnected";
    repo = "bimmer_connected";
    rev = "refs/tags/${version}";
    hash = "sha256-cx22otbBCSFRTfr+wY1+k5kyX6h9mTQfRBfPw3rplzY=";
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

  postInstall = ''
    cp -R bimmer_connected/tests/responses $out/${python.sitePackages}/bimmer_connected/tests/
  '';

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    respx
    time-machine
  ];

  preCheck = ''
    export TZDIR=${tzdata}/${python.sitePackages}/tzdata/zoneinfo
  '';

  pythonImportsCheck = [
    "bimmer_connected"
  ];

  meta = with lib; {
    changelog = "https://github.com/bimmerconnected/bimmer_connected/releases/tag/${version}";
    description = "Library to read data from the BMW Connected Drive portal";
    homepage = "https://github.com/bimmerconnected/bimmer_connected";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
