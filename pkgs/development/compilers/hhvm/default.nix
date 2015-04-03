{ stdenv, fetchgit, cmake, pkgconfig, boost, libunwind, libmemcached, pcre
, libevent, gd, curl, libxml2, icu, flex, bison, openssl, zlib, php, re2c
, expat, libcap, oniguruma, libdwarf, libmcrypt, tbb, gperftools, glog, krb5
, bzip2, openldap, readline, libelf, uwimap, binutils, cyrus_sasl, pam, libpng
, libxslt, ocaml, freetype, gdb, git, perl, mariadb, gmp, libyaml, libedit
, libvpx, imagemagick, fribidi
}:

stdenv.mkDerivation rec {
  name    = "hhvm-${version}";
  version = "3.6.0";

  # use git version since we need submodules
  src = fetchgit {
    url    = "https://github.com/facebook/hhvm.git";
    rev    = "6ef13f20da20993dc8bab9eb103f73568618d3e8";
    sha256 = "29a2d4b56cfd348b199d8f90b4e4b07de85dfb2ef1538479cd1e84f5bc1fbf96";
    fetchSubmodules = true;
  };

  buildInputs =
    [ cmake pkgconfig boost libunwind mariadb libmemcached pcre gdb git perl
      libevent gd curl libxml2 icu flex bison openssl zlib php expat libcap
      oniguruma libdwarf libmcrypt tbb gperftools bzip2 openldap readline
      libelf uwimap binutils cyrus_sasl pam glog libpng libxslt ocaml krb5
      gmp libyaml libedit libvpx imagemagick fribidi
    ];

  enableParallelBuilding = true;
  dontUseCmakeBuildDir = true;
  NIX_LDFLAGS = "-lpam -L${pam}/lib";
  MYSQL_INCLUDE_DIR="${mariadb}/include/mysql";
  MYSQL_DIR=mariadb;

  # work around broken build system
  NIX_CFLAGS_COMPILE = "-I${freetype}/include/freetype2";

  prePatch = ''
    substituteInPlace hphp/util/generate-buildinfo.sh \
      --replace /bin/bash ${stdenv.shell}
    substituteInPlace ./configure \
      --replace "/usr/bin/env bash" ${stdenv.shell}
  '';

  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" ];

  meta = {
    description = "High-performance JIT compiler for PHP/Hack";
    homepage    = "http://hhvm.com";
    license     = "PHP/Zend";
    platforms   = [ "x86_64-linux" ];
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
