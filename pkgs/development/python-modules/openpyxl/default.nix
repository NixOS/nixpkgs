{
  lib,
  buildPythonPackage,
  et-xmlfile,
  fetchFromGitLab,
  lxml,
  pandas,
  pillow,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "openpyxl";
  version = "3.1.5";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "foss.heptapod.net";
    owner = "openpyxl";
    repo = "openpyxl";
    tag = finalAttrs.version;
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

  meta = {
    description = "Python library to read/write Excel 2010 xlsx/xlsm files";
    homepage = "https://openpyxl.readthedocs.org";
    changelog = "https://foss.heptapod.net/openpyxl/openpyxl/-/blob/${finalAttrs.version}/doc/changes.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lihop ];
  };
})
