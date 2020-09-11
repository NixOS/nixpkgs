{ stdenv
, fetchurl

, gettext
, gnutls
, nettle
, pkgconfig
, libiconv
, ApplicationServices
}:

stdenv.mkDerivation rec {
  pname = "libfilezilla";
  version = "0.24.0";

  src = fetchurl {
    url = "https://download.filezilla-project.org/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "1372i9f501kn8p1vkqdydaqvvi6lzxsnw2yzyxx5j4syqd4p0qa5";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ gettext gnutls nettle ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ libiconv ApplicationServices ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "https://lib.filezilla-project.org/";
    description = "A modern C++ library, offering some basic functionality to build high-performing, platform-independent programs";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.unix;
  };
}
