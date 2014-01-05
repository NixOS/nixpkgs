{ stdenv, fetchgit, boost, zlib, libevent, openssl, python, automake, autoconf,
libtool, pkgconfig, bison, flex }:

stdenv.mkDerivation {
  name = "thrift-0.9.1";

  # I take git, because the tarball is broken.
  # http://stackoverflow.com/questions/18643642/libtool-error-building-thrift-0-9-1-on-ubuntu-13-04
  src = fetchgit {
    url = "https://git-wip-us.apache.org/repos/asf/thrift.git";
    rev = "ff980c1432936c6bc897c60469ab05b5e0c6cb5e";
    md5 = "466aca9e43e43df868f4385af50e32f6";
  };

  enableParallelBuilding = true;
  buildInputs = [ boost zlib libevent openssl python automake autoconf libtool
      pkgconfig bison flex ];

  preConfigure = "sh bootstrap.sh; export PY_PREFIX=$out";

  meta = {
    homepage = http://thrift.apache.org/;
    license = "ASL2.0";
    description = "Library for scalable cross-language services";
  };
}
