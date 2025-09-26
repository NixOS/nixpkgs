{
  lib,
  buildPythonPackage,
  et-xmlfile,
  fetchFromGitLab,
  lxml,
  pandas,
  pillow,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "openpyxl";
  version = "3.1.5";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitLab {
    domain = "foss.heptapod.net";
    owner = "openpyxl";
    repo = "openpyxl";
    rev = "refs/tags/${version}";
    hash = "sha256-vp+TIWcHCAWlDaBcmC7w/kV7DZTZpa6463NusaJmqKo=";
  };

  build-system = [ setuptools ];

  dependencies = [ et-xmlfile ];

  nativeCheckInputs = [
    lxml
    pandas
    pillow
    pytestCheckHook
  ];

  pytestFlags = [
    "-Wignore::DeprecationWarning"
  ];

  disabledTests = [
    # lxml 6.0
    "test_iterparse"
  ];

  pythonImportsCheck = [ "openpyxl" ];

  meta = with lib; {
    description = "Python library to read/write Excel 2010 xlsx/xlsm files";
    homepage = "https://openpyxl.readthedocs.org";
    changelog = "https://foss.heptapod.net/openpyxl/openpyxl/-/blob/${version}/doc/changes.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ lihop ];
  };
}
