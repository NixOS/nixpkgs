{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools,
  numpy,
  opencv-python,
  lxml,
  xmljson,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "imantics";
  version = "0.1.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jsbroks";
    repo = "imantics";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QsNpLkltXLsxYL0ddPyGJrE19b08uVwCsN37hzqy2WI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    opencv-python
    lxml
    xmljson
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "imantics" ];

  meta = {
    description = "Convert and visualize many annotation formats for object detection and localization";
    homepage = "https://github.com/jsbroks/imantics";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.rakesh4g ];
  };
})
