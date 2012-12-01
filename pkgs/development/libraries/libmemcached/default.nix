{ stdenv, fetchurl, cyrus_sasl, libevent }:

stdenv.mkDerivation rec {
  name = "libmemcached-1.0.14";
  
  src = fetchurl {
    url = https://launchpad.net/libmemcached/1.0/1.0.14/+download/libmemcached-1.0.14.tar.gz;
    sha256 = "0swl3r7m35rx7abkfycpcknbf83y7l2azq9zscms2rc99cnfmsij";
  };
  
  buildInputs = [ cyrus_sasl libevent ];

  meta = {
    homepage = http://libmemcached.org;
    description = "libMemcached is an open source C/C++ client library and tools for the memcached server.";
    license = "BSD";
  };
}
