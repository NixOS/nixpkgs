{ stdenv, mkDerivation, fetchFromGitHub, pkgconfig, qmake, gsettings-qt, pythonPackages, deepin }:

mkDerivation rec {
  pname = "dtkcore";
  version = "2.0.14";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "0yc6zx8rhzg9mj2brggcsr1jy1pzfvgqy1h305y2dwnx5haazd04";
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
    "MKSPECS_INSTALL_DIR=${placeholder "out"}/mkspecs"
  ];

  postFixup = ''
    chmod +x $out/lib/dtk2/*.py
    wrapPythonProgramsIn "$out/lib/dtk2" "$out $pythonPath"
    searchHardCodedPaths $out  # debugging
  '';

  enableParallelBuilding = true;

  passthru.updateScript = deepin.updateScript { inherit ;name = "${pname}-${version}"; };

  meta = with stdenv.lib; {
    description = "Deepin tool kit core modules";
    homepage = https://github.com/linuxdeepin/dtkcore;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
