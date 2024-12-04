{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  matplotlib,
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

  dependencies = [ matplotlib ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "mplcursors" ];

  meta = with lib; {
    description = "Interactive data selection cursors for Matplotlib";
    homepage = "https://github.com/anntzer/mplcursors";
    license = licenses.zlib;
    maintainers = with maintainers; [ gm6k ];
  };
}
