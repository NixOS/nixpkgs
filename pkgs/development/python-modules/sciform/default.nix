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
  version = "0.39.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jagerber48";
    repo = "sciform";
    tag = version;
    hash = "sha256-5rgTnvckR9bGDgcVZEie+swpc5MEwKQuFHa7zvHiqr8=";
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
    description = "A package for formatting numbers into scientific formatted strings";
    homepage = "https://sciform.readthedocs.io/en/stable/";
    downloadPage = "https://github.com/jagerber48/sciform";
    changelog = "https://github.com/jagerber48/sciform/blob/${src.tag}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
