{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  cairocffi,
  cffi,
  strenum,
  psutil,
  xcffib,
  pdm-backend,
  pytestCheckHook,
  pyside6,
  pyvirtualdisplay,
  qtile,
  extraPackages ? [ ],
}:

buildPythonPackage rec {
  pname = "qtile-bonsai";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aravinda0";
    repo = "qtile-bonsai";
    rev = "refs/tags/v${version}";
    hash = "sha256-IWy/YEVdZc+UgIKl75ZpOkOIvpS5hCX0ihQenUOuJHo=";
  };

  build-system = [
    setuptools
    pdm-backend
  ];

  dependencies = extraPackages ++ [
    strenum
    psutil
    pyside6
    pyvirtualdisplay
    setuptools
    setuptools-scm
    (cairocffi.override { withXcffib = true; })
    cffi
    xcffib
    qtile
  ];

  nativeCheckInputs = [
    pytestCheckHook
    qtile
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTestPaths = [
    # Needs a running DBUS
    "tests/integration/test_layout.py"
    "tests/integration/test_widget.py"
  ];

  pythonImportCheck = [ "qtile-bonsai" ];

  meta = with lib; {
    description = "A flexible custom layout for the qtile window manager that supports arbitrarily nestable tabs and splits.";
    homepage = "https://github.com/aravinda0/qtile-bonsai";
    changelog = "https://github.com/aravinda0/qtile-bonsai/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ gurjaka ];
  };
}
