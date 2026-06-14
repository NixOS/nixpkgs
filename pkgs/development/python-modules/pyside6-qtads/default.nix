{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  replaceVars,

  # buildInputs
  qt6,

  # build-system
  cmake-build-extension,
  setuptools,
  setuptools-scm,

  # dependencies
  pyside6,
  shiboken6,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyside6-qtads";
  version = "4.5.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mborgerson";
    repo = "pyside6_qtads";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-XEcO1+NUEqi/voaNGWLaH+uILY+pfhKMIxckcGwq4mU=";
  };

  # bypass the broken parts of their bespoke python script cmake plugin
  patches = [
    (replaceVars ./find-nix-deps.patch {
      inherit shiboken6 pyside6;
    })
  ];

  # can't use pythonRelaxDepsHook because it runs postBuild but the dependency check
  #  happens during build.
  # -Essentials is a smaller version of PySide6, but the name mismatch breaks build
  # _generator is also a virtual package with the same issue
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"PySide6-Essentials",' "" \
      --replace-fail '"shiboken6_generator",' ""
  '';

  buildInputs = [
    qt6.qtbase
    qt6.qtquick3d
  ];

  build-system = [
    cmake-build-extension
    setuptools
    setuptools-scm
  ];

  dependencies = [
    pyside6
    shiboken6
  ];

  # cmake-build-extension will configure
  dontUseCmakeConfigure = true;

  dontWrapQtApps = true;
  # runtime deps check fails on the pyside6-essentials virtual package
  # dontCheckRuntimeDeps = true;

  pythonImportsCheck = [ "PySide6QtAds" ];

  meta = {
    description = "Python bindings to Qt Advanced Docking System for PySide6";
    homepage = "https://github.com/mborgerson/pyside6_qtads";
    changelog = "https://github.com/mborgerson/pyside6_qtads/releases/tag/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ scoder12 ];
  };
})
