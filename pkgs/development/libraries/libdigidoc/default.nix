{ stdenv, fetchurl, cmake, openssl, pcsclite, opensc, libxml2 }:

stdenv.mkDerivation rec {

  version = "3.10.4";
  name = "libdigidoc-${version}";

  src = fetchurl {
    url = "https://github.com/open-eid/libdigidoc/releases/download/v${version}/libdigidoc-${version}.tar.gz";
    sha256 = "0w5wsaj2a5wss1r9j39bfsrkp3xz0w3v1gnr190v6k7l74l453w1";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ openssl pcsclite opensc libxml2 ];

  meta = with stdenv.lib; {
    description = "Library for creating DigiDoc signature files";
    homepage = http://www.id.ee/;
    license = licenses.lgpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.jagajaga ];
  };
}
