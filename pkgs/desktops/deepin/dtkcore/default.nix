{ stdenv, fetchFromGitHub, pkgconfig, qmake, gsettings-qt, pythonPackages }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "dtkcore";
  version = "2.0.9";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "0jfl4w3sviy59rl41a5507dbhqhsxy7hqw3gf64a57gjlbdskmm1";
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
    sed -i src/src.pro src/dtk_module.prf \
      -e "s,\$\''${QT_HOST_DATA}/mkspecs,$out/mkspecs,"

    sed -i tools/script/dtk-translate.py \
      -e "s,#!env,#!/usr/bin/env,"
  '';

  postFixup = ''
    chmod +x $out/lib/dtk2/*.py
    wrapPythonProgramsIn "$out/lib/dtk2" "$out $pythonPath"
  '';

  meta = with stdenv.lib; {
    description = "Deepin tool kit core modules";
    homepage = https://github.com/linuxdeepin/dtkcore;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
