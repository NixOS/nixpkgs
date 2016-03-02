{ stdenv, fetchgit, pkgconfig
, cmake
, qt54
, libexif
, libpthreadstubs
, libXdmcp
, libXfixes
, lxqt-libfm
, lxqt-pcmanfm-qt
, standardPatch
}:

stdenv.mkDerivation rec {
  basename = "lximage-qt";
  version = "0.4.0";
  name = "${basename}-${version}";

  src = fetchgit {
    url = "https://github.com/lxde/${basename}.git";
    rev = "c50999e7e2db6bb73b26a41bffa3834d75dc36e8";
    sha256 = "cc14c1ab28b0b2433c4af4268a0834aeb2b1d339ed26c35f3b26cff042a4b4a1";
  };

  buildInputs = [
    stdenv pkgconfig
    cmake
    qt54.base qt54.tools qt54.x11extras
    libexif libpthreadstubs libXdmcp libXfixes
    lxqt-libfm lxqt-pcmanfm-qt
  ];

  patchPhase = standardPatch;

  meta = {
    homepage = "http://www.lxqt.org";
    description = "Image viewer";
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.ellis ];
  };
}
