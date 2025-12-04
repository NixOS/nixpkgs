{
  lib,
  stdenv,
  fetchFromGitLab,
  gitUpdater,
  testers,
  glib,
  gobject-introspection,
  pkg-config,
  qmake,
  qtbase,
  qtdeclarative,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gsettings-qt";
  version = "0.2";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/gsettings-qt";
    rev = "v${finalAttrs.version}";
    hash = "sha256-IlW8Aw5fRM6Vox807SjqwowIcPdsBLXwZKlJwuHtiJI=";
  };

  outputs = [
    "out"
    "dev"
  ];

  # Current version still uses QMake
  strictDeps = false;

  nativeBuildInputs = [
    pkg-config
    qmake
    gobject-introspection
  ];

  buildInputs = [
    glib
    qtdeclarative
  ];

  # Library
  dontWrapQtApps = true;

  postPatch = ''
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

  postInstall =
    # QMake-generated pkg-config files, hence fixes being done here
    ''
      substituteInPlace $out/lib/pkgconfig/gsettings-qt.pc \
        --replace-fail 'prefix=${lib.getDev qtbase}' 'prefix=${placeholder "out"}' \
        --replace-fail 'includedir=${placeholder "out"}' 'includedir=${placeholder "dev"}'
    '';

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = gitUpdater {
      rev-prefix = "v";
    };
  };

  meta = {
    description = "Library to access GSettings from Qt";
    homepage = "https://gitlab.com/ubports/core/gsettings-qt";
    license = lib.licenses.lgpl3Only;
    teams = [ lib.teams.lomiri ];
    platforms = lib.platforms.linux;
    pkgConfigModules = [
      "gsettings-qt"
    ];
  };
})
