{
  stdenv,
  lib,
  fetchFromGitLab,
  accounts-qt,
  dbus-test-runner,
  pkg-config,
  qmake,
  qtbase,
  qtdeclarative,
  signond,
  xvfb-run,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "accounts-qml-module";
  version = "0.7-unstable-2022-10-28";

  src = fetchFromGitLab {
    owner = "accounts-sso";
    repo = "accounts-qml-module";
    rev = "05e79ebbbf3784a87f72b7be571070125c10dfe3";
    hash = "sha256-ZpnkZauowLPBnO3DDDtG/x07XoQGVNqEF8AQB5TZK84=";
  };

  postPatch =
    ''
      substituteInPlace src/src.pro \
        --replace '$$[QT_INSTALL_BINS]/qmlplugindump' 'qmlplugindump' \
        --replace '$$[QT_INSTALL_QML]' '${placeholder "out"}/${qtbase.qtQmlPrefix}'

      # Don't install test binary
      sed -i tests/tst_plugin.pro \
        -e '/TARGET = tst_plugin/a INSTALLS -= target'
    ''
    + lib.optionalString (!finalAttrs.doCheck) ''
      sed -i accounts-qml-module.pro -e '/tests/d'
    '';

  # QMake can't find Qt modules in buildInputs
  strictDeps = false;

  nativeBuildInputs = [
    pkg-config
    qmake
    qtdeclarative # qmlplugindump
  ];

  buildInputs = [
    accounts-qt
    qtbase
    qtdeclarative
    signond
  ];

  nativeCheckInputs = [
    dbus-test-runner
    xvfb-run
  ];

  dontWrapQtApps = true;

  qmakeFlags = [
    # Needs qdoc, https://github.com/NixOS/nixpkgs/pull/245379
    "CONFIG+=no_docs"
  ];

  postConfigure = ''
    make qmake_all
  '';

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  preCheck = ''
    # Needs xcb platform plugin
    export QT_PLUGIN_PATH=${lib.getBin qtbase}/${qtbase.qtPluginPrefix}
  '';

  preInstall = ''
    # Same plugin needed here, re-export in case checks are disabled
    export QT_PLUGIN_PATH=${lib.getBin qtbase}/${qtbase.qtPluginPrefix}
  '';

  meta = with lib; {
    description = "QML bindings for libaccounts-qt + libsignon-qt";
    homepage = "https://gitlab.com/accounts-sso/accounts-qml-module";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.linux;
  };
})
