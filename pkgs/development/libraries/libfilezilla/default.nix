{ stdenv
, fetchurl

, gettext
, gnutls
, nettle
, pkgconfig
}:

stdenv.mkDerivation rec {
  pname = "libfilezilla";
  version = "0.20.0";

  src = fetchurl {
    url = "https://download.filezilla-project.org/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "18jk5izk8x4afkzrzm70spb3mkgqd7lgshpjzf6nz314bprb507d";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gettext gnutls nettle ];

  meta = with stdenv.lib; {
    homepage = "https://lib.filezilla-project.org/";
    description = "A modern C++ library, offering some basic functionality to build high-performing, platform-independent programs";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}
