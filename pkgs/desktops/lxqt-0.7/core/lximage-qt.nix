{ stdenv, fetchgit, pkgconfig
, cmake
, qt48

, libexif
, libfm
, libpthreadstubs
, libXdmcp

, pcmanfm-qt
}:

stdenv.mkDerivation rec {
  basename = "lximage-qt";
  version = "0.2.0";
  name = "${basename}-${version}";

  src = fetchgit {
    url = "https://github.com/lxde/${basename}.git";
    rev = "17669ee2195d145343f4a5ee0f431a2c3067ce08";
    sha256 = "b56d69bda51ae90f435eeb59ec1bc9bae07c55691928ca54ed1c4c9064e60e3e";
  };

  buildInputs = [
    stdenv pkgconfig
    cmake qt48
	libexif libfm libpthreadstubs libXdmcp
	pcmanfm-qt
  ];

  meta = {
    homepage = "http://www.lxqt.org";
    description = "Image viewer";
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.ellis ];
  };
}
