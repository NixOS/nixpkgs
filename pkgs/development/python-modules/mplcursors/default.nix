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
  version = "0.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "anntzer";
    repo = "mplcursors";
    rev = "v${version}";
    hash = "sha256-L5pJqRpgPRQEsRDoP10+Pi8uzH5TQNBuGRx7hIL1x7s=";
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
