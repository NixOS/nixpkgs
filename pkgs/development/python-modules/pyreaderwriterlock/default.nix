{
  lib,
  fetchFromGitHub,
  buildPythonPackage,

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

  meta = {
    changelog = "https://github.com/elarivie/pyReaderWriterLock/blob/master/CHANGELOG.md";
    description = "Implementation of the Readers-writers problem";
    homepage = "https://github.com/elarivie/pyReaderWriterLock";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ MayNiklas ];
  };
}
