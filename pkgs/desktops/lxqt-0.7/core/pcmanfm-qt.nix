{ stdenv, fetchgit, pkgconfig
, cmake
, qt48

, libfm
, menu-cache
, libpthreadstubs
, libXdmcp
}:

stdenv.mkDerivation rec {
  basename = "pcmanfm-qt";
  version = "0.7.0";
  name = "${basename}-${version}";

  src = fetchgit {
    url = "https://github.com/lxde/${basename}.git";
    rev = "e20179a751d63ee928a369c06b2d469c3b120b87";
    sha256 = "720aa7aba5a617b4d627e562d23c5a4b0b1fc4efceb37ae05215c55060f698a7";
  };

  buildInputs = [
    stdenv pkgconfig
    cmake qt48
    libfm menu-cache
    libpthreadstubs libXdmcp
  ];

  meta = {
    homepage = "http://www.lxqt.org";
    description = "file manager + desktop manager";
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.ellis ];
  };
}
