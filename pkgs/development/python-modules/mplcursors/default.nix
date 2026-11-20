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
  version = "0.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "anntzer";
    repo = "mplcursors";
    rev = "v${version}";
    hash = "sha256-ZHX//AUVSF91cHxyiL4klglJ2Ef3iSE6oOancL+gQbA=";
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
