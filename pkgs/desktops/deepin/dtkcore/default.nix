{ stdenv, fetchFromGitHub, pkgconfig, qmake, gsettings-qt, pythonPackages, deepin }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "dtkcore";
  version = "2.0.12.1";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "1akfzkdhgsndm6rlr7snhpznxj0w351v6rr8vvnr6ka2dw75xsl4";
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

  qmakeFlags = [ "MKSPECS_INSTALL_DIR=${placeholder "out"}/mkspecs" ];

  postFixup = ''
    chmod +x $out/lib/dtk2/*.py
    wrapPythonProgramsIn "$out/lib/dtk2" "$out $pythonPath"
    searchHardCodedPaths $out  # debugging
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
