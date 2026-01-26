{
  lib,
  stdenv,
  fetchurl,
  fox_1_6,
  fontconfig,
  freetype,
  pkg-config,
  gettext,
  xcbutil,
  gcc,
  intltool,
  file,
  libpng,
  libxft,
  libx11,
}:

stdenv.mkDerivation rec {
  pname = "xfe";
  version = "2.1.2";

  src = fetchurl {
    url = "mirror://sourceforge/xfe/xfe-${version}.tar.xz";
    sha256 = "sha256-jgDgd/DOB92v19SAGqBnTHIYQE+EohgDvvFCwTNDJlE=";
  };

  nativeBuildInputs = [
    pkg-config
    intltool
  ];
  buildInputs = [
    fox_1_6
    gettext
    xcbutil
    gcc
    file
    libpng
    fontconfig
    freetype
    libx11
    libxft
  ];

  preConfigure = ''
    sed -i s,/usr/share/xfe,$out/share/xfe, src/xfedefs.h
  '';

  enableParallelBuilding = true;

  meta = {
    description = "MS-Explorer like file manager for X";
    longDescription = ''
      X File Explorer (Xfe) is an MS-Explorer like file manager for X.
      It is based on the popular, but discontinued, X Win Commander, which was developed by Maxim Baranov.
      Xfe aims to be the filemanager of choice for all the Unix addicts!
    '';
    homepage = "https://sourceforge.net/projects/xfe/";
    license = lib.licenses.gpl2;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
