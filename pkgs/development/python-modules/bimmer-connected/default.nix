{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pbr
, requests
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "bimmer-connected";
  version = "0.7.18";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "bimmerconnected";
    repo = "bimmer_connected";
    rev = version;
    sha256 = "sha256-90Rli0tiZIO2gtx3EfPXg8U6CSKEmHUiRePjITvov/E=";
  };

  nativeBuildInputs = [
    pbr
  ];

  PBR_VERSION = version;

  propagatedBuildInputs = [
    requests
  ];

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Library to read data from the BMW Connected Drive portal";
    homepage = "https://github.com/bimmerconnected/bimmer_connected";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
