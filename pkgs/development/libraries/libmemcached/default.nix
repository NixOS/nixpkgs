{ stdenv, fetchurl, cyrus_sasl, libevent }:

stdenv.mkDerivation rec {
  name = "libmemcached-1.0.18";
  
  src = fetchurl {
    url = https://launchpad.net/libmemcached/1.0/1.0.18/+download/libmemcached-1.0.18.tar.gz;
    sha256 = "10jzi14j32lpq0if0p9vygcl2c1352hwbywzvr9qzq7x6aq0nb72";
  };
  
  buildInputs = [ cyrus_sasl libevent ];

  meta = {
    homepage = http://libmemcached.org;
    description = "Open source C/C++ client library and tools for the memcached server";
    license = "BSD";
  };
}
