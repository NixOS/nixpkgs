{
  lib,
  stdenv,
  fetchFromGitLab,
  pkg-config,
  qmake,
  qtbase,
  qtdeclarative,
  wrapQtAppsHook,
  glib,
  gobject-introspection,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "gsettings-qt";
  version = "0.2";

  src = fetchFromGitLab {
    group = "ubports";
    owner = "core";
    repo = pname;
    rev = "v${version}";
    sha256 = "14l8xphw4jd9ckqba13cyxq0i362x8lfsd0zlfawwi2z1q1vqm92";
  };

  nativeBuildInputs = [
    pkg-config
    qmake
    gobject-introspection
    wrapQtAppsHook
  ];

  buildInputs = [
    glib
    qtdeclarative
  ];

  patchPhase = ''
    # force ordered build of subdirs
    sed -i -e "\$aCONFIG += ordered" gsettings-qt.pro

    # It seems that there is a bug in qtdeclarative: qmlplugindump fails
    # because it can not find or load the Qt platform plugin "minimal".
    # A workaround is to set QT_PLUGIN_PATH and QML2_IMPORT_PATH explicitly.
    export QT_PLUGIN_PATH=${qtbase.bin}/${qtbase.qtPluginPrefix}
    export QML2_IMPORT_PATH=${qtdeclarative.bin}/${qtbase.qtQmlPrefix}

    substituteInPlace GSettings/gsettings-qt.pro \
      --replace '$$[QT_INSTALL_QML]' "$out/$qtQmlPrefix" \
      --replace '$$[QT_INSTALL_BINS]/qmlplugindump' "qmlplugindump"

    substituteInPlace src/gsettings-qt.pro \
      --replace '$$[QT_INSTALL_LIBS]' "$out/lib" \
      --replace '$$[QT_INSTALL_HEADERS]' "$out/include"
  '';

  preInstall = ''
    # do not install tests
    for f in tests/Makefile{,.cpptest}; do
      substituteInPlace $f \
        --replace "install: install_target" "install: "
    done
  '';

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = with lib; {
    description = "Library to access GSettings from Qt";
    homepage = "https://gitlab.com/ubports/core/gsettings-qt";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
