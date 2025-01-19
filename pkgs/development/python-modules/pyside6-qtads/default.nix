{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cmake,
  cmake-build-extension,
  pyside6,
  setuptools,
  setuptools-scm,
  shiboken6,
  wheel,
  python,
  qt6,
}:

buildPythonPackage rec {
  pname = "pyside6-qtads";
  version = "4.3.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mborgerson";
    repo = "pyside6_qtads";
    rev = "v${version}";
    hash = "sha256-WSthRtK9IaRDDFEtGMUsQwylD+iGdsZM2vkXBjt8+mI=";
    fetchSubmodules = true;
  };

  # bypass the broken parts of their bespoke python script cmake plugin
  patches = [ ./find-nix-deps.patch ];
  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail @shiboken6@ ${shiboken6} \
      --replace-fail @pyside6@ ${pyside6}
  '';

  buildInputs = [
    qt6.qtbase
    qt6.qtquick3d
    shiboken6
    pyside6
  ];
  build-system = [
    # cmake
    cmake-build-extension
    pyside6
    setuptools
    setuptools-scm
    shiboken6
    wheel
    pyside6
    shiboken6
  ];

  dependencies = [
    pyside6
    shiboken6
  ];

  # cmake-build-extension will configure
  dontUseCmakeConfigure = true;

  dontWrapQtApps = true;
  # runtime deps check fails on the pyside6-essentials virtual package
  dontCheckRuntimeDeps = true;

  pythonImportsCheck = [ "PySide6QtAds" ];

  meta = {
    description = "Python bindings to Qt Advanced Docking System for PySide6";
    homepage = "https://github.com/mborgerson/pyside6_qtads";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ scoder12 ];
  };
}
