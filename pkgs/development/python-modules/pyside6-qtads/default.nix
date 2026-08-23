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
  shiboken6-generator,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyside6-qtads";
  version = "5.0.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mborgerson";
    repo = "pyside6_qtads";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "";
  };

  # bypass the broken parts of their bespoke python script cmake plugin
  patches = [
    (replaceVars ./find-nix-deps.patch {
      shiboken6 = shiboken6-generator;
      inherit pyside6;
    })
  ];

  # can't use pythonRelaxDepsHook because it runs postBuild but the dependency check
  #  happens during build.
  # -Essentials is a smaller version of PySide6, but the name mismatch breaks build
  # _generator is also a virtual package with the same issue
  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail @shiboken6@ ${shiboken6-generator} \
      --replace-fail @pyside6@ ${pyside6}
  '';
  # can't use pythonRelaxDepsHook because it runs postBuild but the dependency check
  #  happens during build.
  # -Essentials is a smaller version of PySide6, but the name mismatch breaks build
  # _generator is also a virtual package with the same issue
  # substituteInPlace pyproject.toml \
  #   --replace-fail '"PySide6-Essentials",' "" \
  #   --replace-fail '"shiboken6_generator"' ""
  #
  # # Disable Py_LIMITED_API - shiboken6 6.11.0 headers use Python 3.13+ APIs
  # # (PyUnicode_AsUTF8AndSize) that are not available in Python 3.12's limited API
  # substituteInPlace setup.py \
  #   --replace-fail 'py_limited_api=True' 'py_limited_api=False'
  # substituteInPlace CMakeLists.txt \
  #   --replace-fail 'target_compile_definitions(''${bindings_library} PRIVATE "-DPy_LIMITED_API=0x03090000")' ""

  buildInputs = [
    qt6.qtbase
    qt6.qtquick3d
  ];

  build-system = [
    cmake-build-extension
    setuptools
    setuptools-scm
  ];

  pythonRemoveDeps = [ "PySide6-Essentials" ];

  dependencies = [
    pyside6
    shiboken6-generator
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
