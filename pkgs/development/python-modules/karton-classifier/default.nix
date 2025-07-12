{
  lib,
  buildPythonPackage,
  chardet,
  fetchFromGitHub,
  setuptools,
  karton-core,
  pytestCheckHook,
  python-magic,
  yara-python,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "karton-classifier";
  version = "2.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = "karton-classifier";
    tag = "v${version}";
    hash = "sha256-YqxRiQ/kJheEJpYDqRNu9FydfnNX3OlGjgfX9Hwv+dM=";
  };

  pythonRelaxDeps = [
    "chardet"
    "python-magic"
  ];

  build-system = [ setuptools ];

  dependencies = [
    chardet
    karton-core
    python-magic
    yara-python
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "karton.classifier" ];

  disabledTests = [
    # Tests expecting results from a different version of libmagic
    "test_process_archive"
    "test_process_misc_csv"
    "test_process_runnable_win32_jar"
    "test_process_runnable_win32_lnk"
  ];

  meta = with lib; {
    description = "File type classifier for the Karton framework";
    homepage = "https://github.com/CERT-Polska/karton-classifier";
    changelog = "https://github.com/CERT-Polska/karton-classifier/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
    mainProgram = "karton-classifier";
  };
}
