{
  lib,
  fetchFromGitHub,
  bash,
  autoconf,
  automake,
  libtool,
  pkg-config,
  libcangjie,
  sqlite,
  buildPythonPackage,
  cython,
}:

buildPythonPackage {
  pname = "pycangjie";
  version = "unstable-2015-05-03";
  format = "other";

  src = fetchFromGitHub {
    owner = "Cangjians";
    repo = "pycangjie";
    rev = "361bb413203fd43bab624d98edf6f7d20ce6bfd3";
    hash = "sha256-sS0Demzm89WtEIN4Efz0OTsUQ/c3gIX+/koekQGOca4=";
  };

  nativeBuildInputs = [
    pkg-config
    libtool
    autoconf
    automake
    cython
  ];
  buildInputs = [
    libcangjie
    sqlite
  ];

  preConfigure = ''
    find . -name '*.sh' -exec sed -e 's@#!/bin/bash@${bash}/bin/bash@' -i '{}' ';'
    sed -i 's@/usr@${libcangjie}@' tests/__init__.py
  '';

  configureScript = "./autogen.sh";

  doCheck = true;

  meta = with lib; {
    description = "Python wrapper to libcangjie";
    homepage = "http://cangjians.github.io/projects/pycangjie/";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.linquize ];
    platforms = platforms.all;
  };
}
