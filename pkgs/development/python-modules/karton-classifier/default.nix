{
  lib,
  buildPythonPackage,
  chardet,
  fetchFromGitHub,
  setuptools,
  karton-core,
  pytestCheckHook,
  python-magic,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "karton-classifier";
  version = "2.0.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = "karton-classifier";
    rev = "refs/tags/v${version}";
    hash = "sha256-DH8I4Lbbs2TVMvYlvh/P2I/7O4+VechP2JDDVHNsTSg=";
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
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "karton.classifier" ];

  disabledTests = [
    # Tests expecting results from a different version of libmagic
    "test_process_archive_ace"
    "test_process_runnable_win32_lnk"
    "test_process_misc_csv"
  ];

  meta = with lib; {
    description = "File type classifier for the Karton framework";
    mainProgram = "karton-classifier";
    homepage = "https://github.com/CERT-Polska/karton-classifier";
    changelog = "https://github.com/CERT-Polska/karton-classifier/releases/tag/v${version}";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
