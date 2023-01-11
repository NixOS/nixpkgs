{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  requests,
  responses,
}:
buildPythonPackage rec {
  pname = "btsmarthub_devicelist";
  version = "0.2.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jxwolstenholme";
    repo = "btsmarthub_devicelist";
    rev = "${version}";
    hash = "sha256-7ncxCpY+A2SuSFa3k21QchrmFs1dPRUMb1r1z/laa6M=";
  };

  propagatedBuildInputs = [
    requests
  ];

  checkInputs = [
    responses
    requests
    pytestCheckHook
  ];

  disabledTests = [
    "test_btsmarthub2_detection_neither_router_present"
  ];

  meta = with lib; {
    description = "Retrieve a list of devices from a bt smarthub or bt smarthub 2 on a local network";
    homepage = "https://github.com/jxwolstenholme/btsmarthub_devicelist";
    license = licenses.mit;
    maintainers = with maintainers; [jamiemagee];
  };
}
