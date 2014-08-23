{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "c-ares-1.10.0";

  src = fetchurl {
    url = "http://c-ares.haxx.se/download/${name}.tar.gz";
    sha256 = "1nyka87yf2jfd0y6sspll0yxwb8zi7kyvajrdbjmh4axc5s1cw1x";
  };

  meta = {
    description = "A C library for asynchronous DNS requests";

    homepage = http://c-ares.haxx.se;

    license = stdenv.lib.licenses.mit;

    maintainers = [ stdenv.lib.maintainers.shlevy ];
  };
}
