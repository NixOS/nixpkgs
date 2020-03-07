{ stdenv, fetchurl, bison, libuuid, curl, libxml2, flex }:

stdenv.mkDerivation rec {
  version = "3.20.5";
  pname = "libdap";

  nativeBuildInputs = [ bison flex ];
  buildInputs = [ libuuid curl libxml2 ];

  src = fetchurl {
    url = "https://www.opendap.org/pub/source/${pname}-${version}.tar.gz";
    sha256 = "17j6ca2qsp69a91lm11mwbs4l8q13xqcdz60l94avl5krymrqg47";
  };

  meta = with stdenv.lib; {
    description = "A C++ SDK which contains an implementation of DAP";
    homepage = https://www.opendap.org/software/libdap;
    license = licenses.lgpl2;
    maintainers = [ maintainers.bzizou ];
    platforms = platforms.linux;
  };
}
