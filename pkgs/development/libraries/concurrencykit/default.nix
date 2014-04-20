{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name    = "concurrencykit-${version}";
  version = "0.4.1";

  src = fetchurl {
    url    = "http://concurrencykit.org/releases/ck-${version}.tar.gz";
    sha256 = "1gi5gpkxvbb6vkhjm9kab7dz1av2i11f1pggxp001rqq2mi3i6aq";
  };

  meta = {
    description = "A library of safe, high-performance concurrent data structures";
    homepage    = "http://concurrencykit.org";
    license     = stdenv.lib.licenses.bsd2;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
