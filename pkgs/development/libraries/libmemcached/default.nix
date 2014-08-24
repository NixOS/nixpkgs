{ stdenv, fetchurl, cyrus_sasl, libevent }:

stdenv.mkDerivation rec {
  name = "libmemcached-1.0.18";
  
  src = fetchurl {
    url = https://launchpad.net/libmemcached/1.0/1.0.18/+download/libmemcached-1.0.18.tar.gz;
    sha256 = "10jzi14j32lpq0if0p9vygcl2c1352hwbywzvr9qzq7x6aq0nb72";
  };
  
  # Fix linking against libpthread (patch from Fedora)
  # https://bugzilla.redhat.com/show_bug.cgi?id=1037707
  # https://bugs.launchpad.net/libmemcached/+bug/1281907
  patches = [ ./libmemcached-fix-linking-with-libpthread.patch ];

  buildInputs = [ cyrus_sasl libevent ];

  meta = with stdenv.lib; {
    homepage = http://libmemcached.org;
    description = "Open source C/C++ client library and tools for the memcached server";
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
