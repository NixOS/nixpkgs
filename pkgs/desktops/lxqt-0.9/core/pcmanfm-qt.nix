{ stdenv, fetchgit, pkgconfig
, cmake
, qt54
, lxqt-libfm
, menu-cache
, libpthreadstubs
, libXdmcp
, standardPatch
}:

stdenv.mkDerivation rec {
  basename = "pcmanfm-qt";
  version = "0.9.0";
  name = "lxqt-${basename}-${version}";

  src = fetchgit {
    url = "https://github.com/lxde/${basename}.git";
    rev = "d73a7b33a693b769e0bcb026192cc87965778aa4";
    sha256 = "6b4d0ce3064861b58e5ef0d26f9e7cff0b286a030b3d40bf41a483107093fc10";
  };

  buildInputs = [
    stdenv pkgconfig
    cmake
    qt54.base qt54.tools qt54.x11extras
    lxqt-libfm menu-cache
    libpthreadstubs libXdmcp
  ];

  patchPhase = standardPatch;

  meta = {
    homepage = "http://wiki.lxde.org/en/PCManFM";
    description = "file manager";
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.ellis ];
  };
}
