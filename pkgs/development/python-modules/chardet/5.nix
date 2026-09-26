{
  lib,
  buildPythonPackage,
  fetchPypi,
  hypothesis,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "chardet";
  version = "5.2.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-Gztv9HmoxBS8P6LAhSmVaVxKAm3NbQYzst0JLKOcHPc=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  disabledTests = [
    # flaky; https://github.com/chardet/chardet/issues/256
    "test_detect_all_and_detect_one_should_agree"
  ];

  pythonImportsCheck = [ "chardet" ];

  meta = {
    changelog = "https://github.com/chardet/chardet/releases/tag/${finalAttrs.version}";
    description = "Universal encoding detector";
    mainProgram = "chardetect";
    homepage = "https://github.com/chardet/chardet";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ ];
  };
})
