{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
  setuptools,
  lxml,
  pymupdf,
  pysrt,
  translatehtml,
}:

buildPythonPackage (finalAttrs: {
  pname = "argos-translate-files";
  version = "1.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LibreTranslate";
    repo = "argos-translate-files";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XCrABdyly249dpam0pSwTWHoli/uijoUYKaHQhCqB7Y=";
  };

  build-system = [ setuptools ];

  dependencies = [
    lxml
    pymupdf
    pysrt
    translatehtml
  ];

  doCheck = true;

  nativeCheckInputs = [
    pytestCheckHook
    # pythonImportsCheck needs a home dir for argostranslatefiles
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "argostranslatefiles" ];

  meta = {
    description = "Translate files using Argos Translate";
    homepage = "https://www.argosopentech.com";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ misuzu ];
  };
})
