{ stdenv, mkDerivation, fetchFromGitHub, pkgconfig, qmake, gsettings-qt, pythonPackages, deepin }:

mkDerivation rec {
  pname = "dtkcore";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "0xdh6mmrv8yr6mjmlwj0fv037parkkwfwlaibcbrskwxqp9iri1y";
  };

  nativeBuildInputs = [
    pkgconfig
    qmake
    pythonPackages.wrapPython
    deepin.setupHook
  ];

  buildInputs = [
    gsettings-qt
  ];

  postPatch = ''
    searchHardCodedPaths  # debugging

    # Fix shebang
    sed -i tools/script/dtk-translate.py -e "s,#!env,#!/usr/bin/env,"
  '';

  qmakeFlags = [
    "DTK_VERSION=${version}"
    "LIB_INSTALL_DIR=${placeholder "out"}/lib"
    "MKSPECS_INSTALL_DIR=${placeholder "out"}/mkspecs"
  ];

  postFixup = ''
    chmod +x $out/lib/libdtk-${version}/DCore/bin/*.py
    wrapPythonProgramsIn "$out/lib/libdtk-${version}/DCore/bin" "$out $pythonPath"
    searchHardCodedPaths $out  # debugging
  '';

  enableParallelBuilding = true;

  passthru.updateScript = deepin.updateScript { name = "${pname}-${version}"; };

  meta = with stdenv.lib; {
    description = "Deepin tool kit core library";
    homepage = https://github.com/linuxdeepin/dtkcore;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
