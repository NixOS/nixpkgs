{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "c-ares-1.12.0";

  src = fetchurl {
    url = "http://c-ares.haxx.se/download/${name}.tar.gz";
    sha256 = "1yv5ygkd813glz8hbagykgp1hlb6450chig061hr7pyw7i0gk4l6";
  };

  meta = with stdenv.lib; {
    description = "A C library for asynchronous DNS requests";
    homepage = http://c-ares.haxx.se;
    license = licenses.mit;
    platforms = platforms.all;
  };
}
