{ stdenv, fetchurl, cyrus_sasl, libevent }:

stdenv.mkDerivation rec {
  name = "libmemcached-1.0.7";
  
  src = fetchurl {
    url = https://launchpad.net/libmemcached/1.0/1.0.7/+download/libmemcached-1.0.7.tar.gz;
    sha256 = "10cdczkgqiirjy7jwfdk49namqi4jiv1djqrf5fxbaiyfg4qdyiy";
  };
  
  buildInputs = [ cyrus_sasl libevent ];

  meta = {
    homepage = http://libmemcached.org;
    description = "libMemcached is an open source C/C++ client library and tools for the memcached server.";
    license = "BSD";
  };
}
