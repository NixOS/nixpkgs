{ stdenv, fetchgit, cmake, pkgconfig, boost, libunwind, mariadb, libmemcached, pcre
, libevent, gd, curl, libxml2, icu, flex, bison, openssl, zlib, php, re2c
, expat, libcap, oniguruma, libdwarf, libmcrypt, tbb, gperftools, glog
, bzip2, openldap, readline, libelf, uwimap, binutils, cyrus_sasl, pam, libpng
, libxslt, ocaml, freetype, gdb
}:

stdenv.mkDerivation rec {
  name    = "hhvm-${version}";
  version = "3.3.0";

  # use git version since we need submodules
  src = fetchgit {
    url    = "https://github.com/facebook/hhvm.git";
    rev    = "e0c98e21167b425dddf1fc9efe78c9f7a36db268";
    sha256 = "0s32v713xgf4iim1zb9sg08sg1r1fs49czar3jxajsi0dwc0lkj9";
    fetchSubmodules = true;
  };

  buildInputs =
    [ cmake pkgconfig boost libunwind mariadb libmemcached pcre gdb
      libevent gd curl libxml2 icu flex bison openssl zlib php expat libcap
      oniguruma libdwarf libmcrypt tbb gperftools bzip2 openldap readline
      libelf uwimap binutils cyrus_sasl pam glog libpng libxslt ocaml
    ];

  enableParallelBuilding = true;
  dontUseCmakeBuildDir = true;
  dontUseCmakeConfigure = true;
  NIX_LDFLAGS = "-lpam -L${pam}/lib";
  USE_HHVM=1;
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
  installPhase = ''
    mkdir -p $out/bin $out/lib
    mv hphp/hhvm/hhvm          $out/bin
    mv hphp/hack/bin/hh_server $out/bin
    mv hphp/hack/bin/hh_client $out/bin
    mv hphp/hack/hhi           $out/lib/hack-hhi

    cat > $out/bin/hhvm-hhi-copy <<EOF
    #!${stdenv.shell}
    cp -R $out/lib/hack-hhi \$1
    EOF
    chmod +x $out/bin/hhvm-hhi-copy
  '';

  meta = {
    description = "High-performance JIT compiler for PHP/Hack";
    homepage    = "http://hhvm.com";
    license     = "PHP/Zend";
    platforms   = [ "x86_64-linux" ];
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
