{ stdenv
, mkDerivation
, fetchFromGitHub
, pkg-config
, qmake
, glib
, deepin-desktop-base
, gsettings-qt
, lshw
, pythonPackages
, deepin
}:

mkDerivation rec {
  pname = "dtkcore";
  version = "5.2.2.3";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "1w5zclf6vqninwhsmir27aaasrqqhp0gnpq3ipm61b5makflg0k2";
  };

  nativeBuildInputs = [
    pkg-config
    qmake
    pythonPackages.wrapPython
    glib
    deepin.setupHook
  ];

  buildInputs = [
    deepin-desktop-base
    gsettings-qt
    lshw
  ];

  postPatch = ''
    searchHardCodedPaths  # debugging

    fixPath ${deepin-desktop-base} /etc/deepin-version src/dsysinfo.cpp

    substituteInPlace src/dsysinfo.cpp --replace \"lshw\" \"${lshw}/bin/lshw\"

    # Fix shebang
    substituteInPlace tools/script/dtk-translate.py --replace "#!env" "#!/usr/bin/env"

    # Fix paths for other dtk modules (which depends on dtkcore)
    substituteInPlace dtk_build_config.prf \
      --replace \
        'LIB_INSTALL_DIR=$''${QT.dtkcore.libs}' \
        'LIB_INSTALL_DIR=$$PREFIX/lib' \
      --replace \
        'INCLUDE_INSTALL_DIR = $''${QT.dtkcore.includes}/../$$DMODULE_NAME' \
        'INCLUDE_INSTALL_DIR = $$PREFIX/include/$$LIB_VERSION_NAME/$$DMODULE_NAME'
  '';

  qmakeFlags = [
    "DTK_VERSION=${version}"
    "MKSPECS_INSTALL_DIR=${placeholder "out"}/mkspecs"
    "QMAKE_PKGCONFIG_PREFIX=${placeholder "out"}"
  ];

  preFixup = ''
    glib-compile-schemas ${glib.makeSchemaPath "$out" "${pname}-${version}"}
  '';

  postFixup = ''
    chmod +x $out/lib/libdtk-*/DCore/bin/*.py
    wrapPythonProgramsIn $out/lib/libdtk-*/DCore/bin "$out $pythonPath"
    wrapQtApp $out/lib/libdtk-*/DCore/bin/deepin-os-release
    wrapQtApp $out/lib/libdtk-*/DCore/bin/dtk-settings
    searchHardCodedPaths $out  # debugging
  '';

  passthru.updateScript = deepin.updateScript { inherit pname version src; };

  meta = with stdenv.lib; {
    description = "Deepin tool kit core library";
    homepage = "https://github.com/linuxdeepin/dtkcore";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
