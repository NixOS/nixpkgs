{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, regex
}:

buildPythonPackage rec {
  pname = "iocextract";
  version = "1.15.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "InQuest";
    repo = "python-iocextract";
    rev = "refs/tags/v${version}";
    hash = "sha256-l0TGi3Y3/Dcwyp80eRWYYlDaDDJdpc31fcxdYEVvQas=";
  };

  propagatedBuildInputs = [
    regex
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "iocextract"
  ];

  pytestFlagsArray = [
    "tests.py"
  ];

  meta = with lib; {
    description = "Module to extract Indicator of Compromises (IOC)";
    homepage = "https://github.com/InQuest/python-iocextract";
    changelog = "https://github.com/InQuest/python-iocextract/releases/tag/v${version}";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ fab ];
  };
}
