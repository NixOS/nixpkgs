{ lib
, buildPythonPackage
, et-xmlfile
, fetchFromGitLab
, jdcal
, lxml
, pillow
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "openpyxl";
  version = "3.1.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitLab {
    domain = "foss.heptapod.net";
    owner = "openpyxl";
    repo = "openpyxl";
    rev = version;
    hash = "sha256-SWRbjA83AOLrfe6on2CSb64pH5EWXkfyYcTqWJNBEP0=";
  };

  propagatedBuildInputs = [
    jdcal
    et-xmlfile
    lxml
  ];

  nativeCheckInputs = [
    pillow
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "openpyxl"
  ];

  meta = with lib; {
    description = "Python library to read/write Excel 2010 xlsx/xlsm files";
    homepage = "https://openpyxl.readthedocs.org";
    changelog = "https://foss.heptapod.net/openpyxl/openpyxl/-/blob/${version}/doc/changes.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ lihop ];
  };
}
