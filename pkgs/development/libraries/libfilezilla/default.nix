{ stdenv, fetchurl, pkgconfig, nettle }:

stdenv.mkDerivation rec {
  name = "libfilezilla-${version}";
  version = "0.15.1";

  src = fetchurl {
    url = "https://download.filezilla-project.org/libfilezilla/${name}.tar.bz2";
    sha256 = "17zlhw5b1a7jzh50cbpy2is3sps5lnzch5yf9qm7mwrviw9c8j10";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ nettle ];

  meta = with stdenv.lib; {
    homepage = https://lib.filezilla-project.org/;
    description = "A modern C++ library, offering some basic functionality to build high-performing, platform-independent programs";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}
