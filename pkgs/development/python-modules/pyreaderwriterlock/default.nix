{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,

  # build-system
  setuptools,

  # dependencies
  typing-extensions,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyreaderwriterlock";
  version = "1.0.9";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "elarivie";
    repo = "pyReaderWriterLock";
    tag = "v${version}";
    hash = "sha256-8FC+4aDgGpF1BmOdlkFtMy7OfWdSmvn9fjKXSmmeJlg=";
  };

  build-system = [ setuptools ];

  dependencies = [ typing-extensions ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "readerwriterlock" ];

  meta = with lib; {
    changelog = "https://github.com/elarivie/pyReaderWriterLock/blob/master/CHANGELOG.md";
    description = "Implementation of the Readers-writers problem";
    homepage = "https://github.com/elarivie/pyReaderWriterLock";
    license = licenses.mit;
    maintainers = with maintainers; [ MayNiklas ];
  };
}
