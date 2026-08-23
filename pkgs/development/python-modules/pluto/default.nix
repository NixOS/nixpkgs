{
  lib,
  buildPythonPackage,
  fetchgit,
  setuptools,
  setuptools-scm,
  pyqt5,
  qt5,
  zapf,
  pytango,
}:

buildPythonPackage (finalAttrs: {
  pname = "pluto";
  version = "3.4.5";
  pyproject = true;

  src = fetchgit {
    url = "https://forge.frm2.tum.de/review/mlz/pils/pluto";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+H9ubjLpepCVF/rgSTuZfm1pjWjHUvYBc9mKHgL3I1Y=";
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

  # wraps $out/bin/pluto with QT_PLUGIN_PATH etc. so it can find the
  # "wayland"/"xcb" platform plugins at runtime - without this you get
  # `qt.qpa.plugin: Could not find the Qt platform plugin` and a crash.
  nativeBuildInputs = [
    qt5.wrapQtAppsHook
  ];

  # wrapQTAppsHook seems to not find the python script.
  # Thus the manual preFixup step
  # https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/qt.section.md
  dontWrapQtApps = true;
  preFixup = ''
    wrapQtApp "$out/bin/pluto"
  '';

  dependencies = [
    pytango
    zapf
    pyqt5
  ];

  pythonImportsCheck = [ "pluto" ];

  meta = {
    description = "PLC debug tool";
    homepage = "https://forge.frm2.tum.de/review/plugins/gitiles/mlz/pils/pluto";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "pluto";
    maintainers = with lib.maintainers; [ tincotema ];
  };
})
