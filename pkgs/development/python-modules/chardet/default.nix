{ lib
, buildPythonPackage
, fetchPypi
, hypothesis
, pythonOlder
, pytestCheckHook
, setuptools
}:

buildPythonPackage rec {
  pname = "chardet";
  version = "5.1.0";
  format = "pyproject";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DWJxK5VrwVT4X7CiZuKjxZE8KWfgA0hwGzJBHW3vMeU=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  checkInputs = [
    # "hypothesis" indirectly depends on chardet to build its documentation.
    (hypothesis.override { enableDocumentation = false; })
    pytestCheckHook
  ];

  disabledTests = [
    # flaky; https://github.com/chardet/chardet/issues/256
    "test_detect_all_and_detect_one_should_agree"
  ];

  pythonImportsCheck = [ "chardet" ];

  meta = with lib; {
    changelog = "https://github.com/chardet/chardet/releases/tag/${version}";
    description = "Universal encoding detector";
    homepage = "https://github.com/chardet/chardet";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ domenkozar ];
  };
}
