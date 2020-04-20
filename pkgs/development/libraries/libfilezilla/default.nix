{ stdenv
, fetchurl

, gettext
, gnutls
, nettle
, pkgconfig
}:

stdenv.mkDerivation rec {
  pname = "libfilezilla";
  version = "0.19.3";

  src = fetchurl {
    url = "https://download.filezilla-project.org/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "0fml6whdbfcwc8nfjhvrnidkscv6q2x988zf3alfjl2mdpw4jgd4";
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
