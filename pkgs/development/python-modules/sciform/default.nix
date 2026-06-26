{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "sciform";
  version = "0.39.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jagerber48";
    repo = "sciform";
    tag = version;
    hash = "sha256-t43v3xnZap6NayzqBVvw2PzPzHZ5QPSEO5aRzS8AKKE=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "sciform"
  ];

  meta = {
    description = "Package for formatting numbers into scientific formatted strings";
    homepage = "https://sciform.readthedocs.io/en/stable/";
    downloadPage = "https://github.com/jagerber48/sciform";
    changelog = "https://github.com/jagerber48/sciform/blob/${src.tag}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
