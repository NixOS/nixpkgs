{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pi1wire";
  version = "0.2.0";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ushiboy";
    repo = "pi1wire";
    rev = "v${version}";
    hash = "sha256-70w71heHWR5yArl+HuNAlzL2Yq/CL0iMNMiQw5qovls=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    "test_find_all_sensors" # flaky
  ];

  pythonImportsCheck = [ "pi1wire" ];

  meta = with lib; {
    description = "1Wire Sensor Library for Raspberry PI";
    homepage = "https://github.com/ushiboy/pi1wire";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
