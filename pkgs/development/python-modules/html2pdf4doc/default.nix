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
  version = "0.0.25";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mettta";
    repo = "html2pdf4doc_python";
    tag = version;
    hash = "sha256-IE0dWnbCwmkRykAsveYSfcoNeGP+HvgTocQ1+cVE0JE=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    requests
    selenium
    webdriver-manager
    pypdf
  ];

  pythonImportsCheck = [ "html2pdf4doc" ];

  nativeCheckInputs = [
    versionCheckHook
  ];

  versionCheckProgramArg = "-v";

  meta = {
    description = "Print HTML to PDF in the Browser – Python Package for HTML2PDF.js";
    homepage = "https://github.com/mettta/html2pdf4doc_python";
    changelog = "https://github.com/mettta/html2pdf4doc_python/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ puzzlewolf ];
  };
}
