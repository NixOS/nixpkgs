{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pymupdf,
  llm,
  llm-pdf-to-images,
  pytestCheckHook,
  pytest-asyncio,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "llm-pdf-to-images";
  version = "0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "llm-pdf-to-images";
    tag = version;
    hash = "sha256-UWtCPdKrGE93NNjCroct5fPhq1pWIkngXXtRb+BHm8k=";
  };

  build-system = [ setuptools ];

  dependencies = [
    llm
    pymupdf
  ];

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "llm_pdf_to_images" ];

  passthru.tests = llm.mkPluginTest llm-pdf-to-images;

  meta = {
    description = "LLM fragment plugin to load a PDF as a sequence of images";
    homepage = "https://github.com/simonw/llm-pdf-to-images";
    changelog = "https://github.com/simonw/llm-pdf-to-images/releases/tag/${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ philiptaron ];
  };
}
