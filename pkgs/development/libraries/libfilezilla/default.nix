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
  version = "0.23.0";

  src = fetchurl {
    url = "https://download.filezilla-project.org/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "0lk84aw5ylrhpy26djdw3byhjbn9qrzx5k98r0i4nwfizckw3smd";
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
