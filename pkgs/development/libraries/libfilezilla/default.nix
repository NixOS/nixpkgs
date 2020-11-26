{ stdenv
, fetchurl
, autoreconfHook
, gettext
, gnutls
, nettle
, pkgconfig
, libiconv
, ApplicationServices
}:

stdenv.mkDerivation rec {
  pname = "libfilezilla";
  version = "0.24.1";

  src = fetchurl {
    url = "https://download.filezilla-project.org/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-/dW07hkWr3sdQC591GfwXfdiS7ZfuVoIdaA3EuzC1v0=";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

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
