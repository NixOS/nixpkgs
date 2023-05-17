{ lib
, buildPythonPackage
, fetchFromGitLab
, pythonOlder
, et_xmlfile
, pytestCheckHook
, lxml
, pillow
}:

buildPythonPackage rec {
  pname = "openpyxl";
  version = "3.1.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitLab {
    domain = "foss.heptapod.net";
    owner = pname;
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-SWRbjA83AOLrfe6on2CSb64pH5EWXkfyYcTqWJNBEP0=";
  };

  propagatedBuildInputs = [
    et_xmlfile
  ];

  nativeCheckInputs = [
    pytestCheckHook
    lxml
    pillow
  ];

  meta = {
    description = "A Python library to read/write Excel 2007 xlsx/xlsm files";
    homepage = "https://openpyxl.readthedocs.org";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lihop ];
  };
}
