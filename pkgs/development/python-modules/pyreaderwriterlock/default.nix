{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,

  # propagates
  typing-extensions,

  # tests
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyreaderwriterlock";
  version = "1.0.9";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "elarivie";
    repo = "pyReaderWriterLock";
    rev = "refs/tags/v${version}";
    hash = "sha256-8FC+4aDgGpF1BmOdlkFtMy7OfWdSmvn9fjKXSmmeJlg=";
  };

  propagatedBuildInputs = [ typing-extensions ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "readerwriterlock" ];

  meta = with lib; {
    changelog = "https://github.com/elarivie/pyReaderWriterLock/blob/master/CHANGELOG.md";
    description = "Implementation of the Readers-writers problem";
    homepage = "https://github.com/elarivie/pyReaderWriterLock";
    license = licenses.mit;
    maintainers = with maintainers; [ MayNiklas ];
  };
}
