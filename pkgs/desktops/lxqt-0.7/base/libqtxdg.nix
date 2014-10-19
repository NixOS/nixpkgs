{ stdenv, fetchgit
, cmake
, file # libmagic.so
, qt48
}:

stdenv.mkDerivation rec {
  basename = "libqtxdg";
  version = "0.5.3";
  name = "${basename}-${version}";

  src = fetchgit {
    url = "https://github.com/lxde/${basename}.git";
    rev = "8199feb8b8484147eff2ea622f0a6169208766ea";
    sha256 = "4291e837d072b7c2b7737b6ef897bb85e38d5d1102ad1a6c195ca71245f21490";
  };

  buildInputs = [ stdenv cmake qt48 file ];

  meta = {
    homepage = "http://www.lxqt.org";
    description = "Library providing freedesktop.org specs implementations for Qt";
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.ellis ];
  };
}
