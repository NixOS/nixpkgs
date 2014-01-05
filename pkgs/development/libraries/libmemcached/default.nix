{ stdenv, fetchurl, cyrus_sasl, libevent }:

stdenv.mkDerivation rec {
  name = "libmemcached-1.0.8";
  
  src = fetchurl {
    url = https://launchpad.net/libmemcached/1.0/1.0.8/+download/libmemcached-1.0.8.tar.gz;
    sha256 = "198wcvhrqjnak0cjnkxmjsr3xkjc1k6yq2a77nlk852gcf8ypx03";
  };
  
  buildInputs = [ cyrus_sasl libevent ];

  meta = {
    homepage = http://libmemcached.org;
    description = "Open source C/C++ client library and tools for the memcached server";
    license = "BSD";
  };
}
