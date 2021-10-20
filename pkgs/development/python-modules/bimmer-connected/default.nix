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
  version = "0.7.20";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "bimmerconnected";
    repo = "bimmer_connected";
    rev = version;
    sha256 = "sha256-vcJYcxBX8wHH3FiU2Cg7IlK0iEQZ3SLVa0MryeAwPCA=";
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
