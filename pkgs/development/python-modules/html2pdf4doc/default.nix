{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pypdf,
  requests,
  selenium,
  versionCheckHook,
  webdriver-manager,
}:

buildPythonPackage (finalAttrs: {
  pname = "html2pdf4doc";
  version = "0.0.35";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "strictdoc-project";
    repo = "html2pdf4doc_python";
    tag = finalAttrs.version;
    hash = "sha256-xq2j39OyBoQPQGpMn7xQiRGq8sBkrqqL8mCjEzSdLAA=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    pypdf
    requests
    selenium
    webdriver-manager
  ];

  pythonImportsCheck = [ "html2pdf4doc" ];

  nativeCheckInputs = [
    versionCheckHook
  ];

  versionCheckProgramArg = "-v";

  meta = {
    description = "Print HTML to PDF in the Browser – Python Package for HTML2PDF.js";
    homepage = "https://github.com/strictdoc-project/html2pdf4doc_python";
    changelog = "https://github.com/strictdoc-project/html2pdf4doc_python/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ puzzlewolf ];
  };
})
