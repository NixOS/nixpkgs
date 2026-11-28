{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools,
  numpy,
  opencv-python,
  lxml,
  xmljson,
  pyprojectVersionPatchHook,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "imantics";
  version = "0.1.12-unstable-2020-09-17";
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

  nativeBuildInputs = [
    # The 'imantics' derivation has version '0.1.12' but .dist-info/METADATA specifies version '0.1.13'.
    pyprojectVersionPatchHook
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
