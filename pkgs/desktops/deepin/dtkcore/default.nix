{ stdenv, fetchFromGitHub, pkgconfig, qmake, gsettings-qt, pythonPackages, deepin }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "dtkcore";
  version = "2.0.9.8";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "06jj5gpy2qbmc21nf0fnbvgw7nbjjgvzx7m2vg9byw5il8l4g22h";
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

  passthru.updateScript = deepin.updateScript { inherit name; };

  meta = with stdenv.lib; {
    description = "Deepin tool kit core modules";
    homepage = https://github.com/linuxdeepin/dtkcore;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
