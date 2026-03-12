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

buildPythonPackage rec {
  pname = "html2pdf4doc";
  version = "0.0.31";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mettta";
    repo = "html2pdf4doc_python";
    tag = version;
    hash = "sha256-ailiZfqO2NacJmCbWWtZ2bnerjc9mdJZKDVWNUTMEAg=";
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
    homepage = "https://github.com/mettta/html2pdf4doc_python";
    changelog = "https://github.com/mettta/html2pdf4doc_python/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ puzzlewolf ];
  };
}
