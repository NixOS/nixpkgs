{ stdenv, fetchbzr, pkgconfig, qmake, qtbase, qtdeclarative, glib, gobjectIntrospection }:

stdenv.mkDerivation rec {
  name = "gsettings-qt-${version}";
  version = "0.1.20170824";

  src = fetchbzr {
    url = http://bazaar.launchpad.net/~system-settings-touch/gsettings-qt/trunk;
    rev = "85";
    sha256 = "1kcw0fgdyndx9c0dyha11wkj0gi05spdc1adf1609mrinbb4rnyi";
  };

  nativeBuildInputs = [
    pkgconfig
    qmake
    gobjectIntrospection
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

  meta = with stdenv.lib; {
    description = "Qt/QML bindings for GSettings";
    homepage = https://launchpad.net/gsettings-qt;
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
