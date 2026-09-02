{
  lib,
  buildPythonPackage,
  fetchgit,
  setuptools,
  setuptools-scm,
  numpy,
  pyqt5,
  qt5,
  psutil,
  pytango,
  qtconsole,
}:

buildPythonPackage (finalAttrs: {
  pname = "quango";
  version = "3.3.8";
  pyproject = true;

  src = fetchgit {
    url = "https://forge.frm2.tum.de/review/frm2/tango/apps/quango";
    rev = "v${finalAttrs.version}";
    hash = "sha256-0txeDVX8ohtZFoIm/5rAmdCz3JyNFIXr0X3E/1GN0G4=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  buildInputs = [
    qt5.qtwayland
  ];

  # setuptools-scm normally derives the version from git tags/history, but
  # fetchgit gives a shallow, tag-less checkout by default. Pin the version
  # explicitly instead of also needing `leaveDotGit`/deepClone = true.
  env.SETUPTOOLS_SCM_PRETEND_VERSION = finalAttrs.version;

  nativeBuildInputs = [
    qt5.wrapQtAppsHook
  ];

  # wrapQTAppsHook seems to not find the python script.
  # Thus the manual preFixup step
  # https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/qt.section.md
  dontWrapQtApps = true;
  preFixup = ''
    wrapQtApp "$out/bin/quango"
    wrapQtApp "$out/bin/quango-mlzgui"
  '';

  dependencies = [
    numpy
    pyqt5
    psutil
    pytango
  ];

  passthru.optional-dependencies = {
    console = [
      qtconsole
    ];
  };

  pythonImportsCheck = [ "quango" ];

  meta = {
    description = "Nice generic user interface for Tango devices";
    homepage = "https://forge.frm2.tum.de/review/plugins/gitiles/frm2/tango/apps/quango";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "quango";
    maintainers = with lib.maintainers; [ tincotema ];
  };
})
