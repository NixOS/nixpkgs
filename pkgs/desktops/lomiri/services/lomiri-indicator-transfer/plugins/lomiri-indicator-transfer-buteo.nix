{
  stdenv,
  lib,
  fetchFromGitLab,
  gitUpdater,
  accounts-qt,
  cmake,
  dbus,
  dbus-test-runner,
  gettext,
  gobject-introspection,
  lomiri-indicator-transfer-unwrapped,
  lomiri-url-dispatcher,
  pkg-config,
  properties-cpp,
  python3,
  qtbase,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-indicator-transfer-buteo";
  version = "0.4";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-indicator-transfer-buteo";
    tag = finalAttrs.version;
    hash = "sha256-2T7fUakO0KYGEO3Ggjw1MAugnFGYzqlS+xZejbkVDVA=";
  };

  patches = [
    ./1001-lomiri-indicator-transfer-buteo-Drop-qt5_use_modules-usage.patch
  ];

  postPatch =
    ''
      substituteInPlace src/CMakeLists.txt \
        --replace-fail 'pkg-config --variable=plugindir lomiri-indicator-transfer' 'pkg-config --define-variable=prefix=''${CMAKE_INSTALL_PREFIX} --variable=plugindir lomiri-indicator-transfer'
    ''
    + (
      if finalAttrs.finalPackage.doCheck then
        ''
          patchShebangs tests/buteo-syncfw.py
        ''
      else
        ''
          substituteInPlace CMakeLists.txt \
            --replace-fail 'add_subdirectory(tests)' '# add_subdirectory(tests)'
        ''
    );

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    gettext
    pkg-config
  ];

  buildInputs = [
    accounts-qt
    lomiri-indicator-transfer-unwrapped
    lomiri-url-dispatcher
    properties-cpp
    qtbase
  ];

  nativeCheckInputs = [
    dbus
    dbus-test-runner
    gobject-introspection
    (python3.withPackages (
      ps: with ps; [
        dbus-python
        pygobject3
      ]
    ))
  ];

  dontWrapQtApps = true;

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  # To make accounts-qt abit happier
  preCheck = ''
    export HOME=$TMPDIR
  '';

  passthru = {
    updateScript = gitUpdater { };
  };

  meta = {
    description = "Buteo plugin for the Lomiri Transfer Indicator";
    homepage = "https://gitlab.com/ubports/development/core/lomiri-indicator-transfer-buteo";
    changelog = "https://gitlab.com/ubports/development/core/lomiri-indicator-transfer-buteo/-/blob/${finalAttrs.version}/ChangeLog";
    license = lib.licenses.gpl3Only;
    maintainers = lib.teams.lomiri.members;
    platforms = lib.platforms.linux;
  };
})
