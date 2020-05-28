{ stdenv
, fetchurl

, gettext
, gnutls
, nettle
, pkgconfig
}:

stdenv.mkDerivation rec {
  pname = "libfilezilla";
  version = "0.22.0";

  src = fetchurl {
    url = "https://download.filezilla-project.org/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "0ylgxw1lxdqvayy5285mlfrkr9cvsgasy2zci6g6mv9rng261xn5";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ gettext gnutls nettle ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "https://lib.filezilla-project.org/";
    description = "A modern C++ library, offering some basic functionality to build high-performing, platform-independent programs";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}
