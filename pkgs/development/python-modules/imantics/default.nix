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

buildPythonPackage {
  pname = "imantics";
  version = "0.1.12-unstable-2020-09-17";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jsbroks";
    repo = "imantics";
    rev = "76d81036d8f92854d63ad9938dd76c718f8b482e";
    hash = "sha256-qP5rhAXHD2KTt+Okboo6YzqIFwvBiOydgHCqxZB8Yv8=";
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
}
