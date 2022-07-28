{ lib
, buildPythonPackage
, fetchPypi
, hypothesis
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "chardet";
  version = "5.0.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-A2jfK/14tfwgVyu06bt/tT4sCU9grpmTM56GcdCvuKo=";
  };

  checkInputs = [
    hypothesis
    pytestCheckHook
  ];

  disabledTests = [
    # flaky; https://github.com/chardet/chardet/issues/256
    "test_detect_all_and_detect_one_should_agree"
  ];

  pythonImportsCheck = [ "chardet" ];

  meta = with lib; {
    description = "Universal encoding detector";
    homepage = "https://github.com/chardet/chardet";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ domenkozar ];
  };
}
