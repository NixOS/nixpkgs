{ stdenv, fetchgit, cmake, pkgconfig, boost, libunwind, libmemcached
, pcre, libevent, gd, curl, libxml2, icu, flex, bison, openssl, zlib, php
, expat, libcap, oniguruma, libdwarf, libmcrypt, tbb, gperftools, glog, libkrb5
, bzip2, openldap, readline, libelf, uwimap, binutils, cyrus_sasl, pam, libpng
, libxslt, freetype, gdb, git, perl, libmysqlclient, gmp, libyaml, libedit
, libvpx, imagemagick, fribidi, gperf, which, ocamlPackages
}:

stdenv.mkDerivation rec {
  pname = "hhvm";
  version = "3.23.2";

  # use git version since we need submodules
  src = fetchgit {
    url    = "https://github.com/facebook/hhvm.git";
    rev    = "HHVM-${version}";
    sha256 = "1nic49j8nghx82lgvz0b95r78sqz46qaaqv4nx48p8yrj9ysnd7i";
    fetchSubmodules = true;
  };

  buildInputs =
    [ cmake pkgconfig boost libunwind libmysqlclient libmemcached pcre gdb git perl
      libevent gd curl libxml2 icu flex bison openssl zlib php expat libcap
      oniguruma libdwarf libmcrypt tbb gperftools bzip2 openldap readline
      libelf uwimap binutils cyrus_sasl pam glog libpng libxslt libkrb5
      gmp libyaml libedit libvpx imagemagick fribidi gperf which
      ocamlPackages.ocaml ocamlPackages.ocamlbuild
    ];

  patches = [
    ./flexible-array-members-gcc6.patch
  ];

  enableParallelBuilding = true;
  dontUseCmakeBuildDir = true;
  NIX_LDFLAGS = "-lpam -L${pam}/lib";

  # work around broken build system
  NIX_CFLAGS_COMPILE = "-I${freetype.dev}/include/freetype2";

  # the cmake package does not handle absolute CMAKE_INSTALL_INCLUDEDIR correctly
  # (setting it to an absolute path causes include files to go to $out/$out/include,
  #  because the absolute path is interpreted with root at $out).
  cmakeFlags = [ "-DCMAKE_INSTALL_INCLUDEDIR=include" ];

  prePatch = ''
    substituteInPlace ./configure \
      --replace "/usr/bin/env bash" ${stdenv.shell}
    substituteInPlace ./third-party/ocaml/CMakeLists.txt \
      --replace "/bin/bash" ${stdenv.shell}
    perl -pi -e 's/([ \t(])(isnan|isinf)\(/$1std::$2(/g' \
      hphp/runtime/base/*.cpp \
      hphp/runtime/ext/std/*.cpp \
      hphp/runtime/ext_zend_compat/php-src/main/*.cpp \
      hphp/runtime/ext_zend_compat/php-src/main/*.h
    sed '1i#include <functional>' -i third-party/mcrouter/src/mcrouter/lib/cycles/Cycles.h
    patchShebangs .
  '';

  meta = {
    description = "High-performance JIT compiler for PHP/Hack";
    homepage    = "https://hhvm.com";
    license     = "PHP/Zend";
    platforms   = [ "x86_64-linux" ];
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
    broken = true; # Since 2018-04-21, see https://hydra.nixos.org/build/73059373
  };
}
