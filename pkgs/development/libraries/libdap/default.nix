{ stdenv, fetchurl, bison, libuuid, curl, libxml2, flex }:

stdenv.mkDerivation rec {
  version = "3.20.0";
  name = "libdap-${version}";

  nativeBuildInputs = [ bison flex ];
  buildInputs = [ libuuid curl libxml2 ];

  src = fetchurl {
    url = "https://www.opendap.org/pub/source/${name}.tar.gz";
    sha256 = "0cr3d7dlzq583dqqrkbs1bkcrwag4hp7hwrx5c0mjk7q4vrslh92";
  };

  meta = with stdenv.lib; {
    description = "A C++ SDK which contains an implementation of DAP";
    homepage = https://www.opendap.org/download/libdap;
    license = licenses.lgpl2;
    maintainers = [ maintainers.bzizou ];
    platforms = platforms.linux;
  };
}
