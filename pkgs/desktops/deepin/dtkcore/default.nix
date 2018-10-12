{ stdenv, fetchFromGitHub, pkgconfig, qmake, gsettings-qt, pythonPackages }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "dtkcore";
  version = "2.0.9.4";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "184yg1501hvv7n1c7r0fl2y4d4nhif368rrbrd1phwzfvh6x1ji4";
  };

  nativeBuildInputs = [
    pkgconfig
    qmake
    pythonPackages.wrapPython
  ];

  buildInputs = [
    gsettings-qt
  ];

  postPatch = ''
    # Only define QT_HOST_DATA if it is empty
    sed '/QT_HOST_DATA=/a }' -i src/dtk_module.prf
    sed '/QT_HOST_DATA=/i isEmpty(QT_HOST_DATA) {' -i src/dtk_module.prf

    # Fix shebang
    sed -i tools/script/dtk-translate.py -e "s,#!env,#!/usr/bin/env,"
  '';

  preConfigure = ''
    qmakeFlags="$qmakeFlags QT_HOST_DATA=$out"
  '';

  postFixup = ''
    chmod +x $out/lib/dtk2/*.py
    wrapPythonProgramsIn "$out/lib/dtk2" "$out $pythonPath"
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Deepin tool kit core modules";
    homepage = https://github.com/linuxdeepin/dtkcore;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
