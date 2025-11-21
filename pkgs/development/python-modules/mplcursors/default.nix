{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  matplotlib,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mplcursors";
  version = "0.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "anntzer";
    repo = "mplcursors";
    rev = "v${version}";
    hash = "sha256-bHBMi9xtawV50xPyR1vsGg+1KmTWjeErP9yh2tZxTIg=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    matplotlib
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "mplcursors"
  ];

  meta = {
    description = "Interactive data selection cursors for Matplotlib";
    homepage = "https://github.com/anntzer/mplcursors";
    changelog = "https://github.com/anntzer/mplcursors/blob/${src.rev}/CHANGELOG.rst";
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
