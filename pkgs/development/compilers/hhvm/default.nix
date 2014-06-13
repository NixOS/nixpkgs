{ stdenv, fetchgit, cmake, boost, libunwind, mariadb, libmemcached, pcre
, libevent, gd, curl, libxml2, icu, flex, bison, openssl, zlib, php, re2c
, expat, libcap, oniguruma, libdwarf, libmcrypt, tbb, gperftools, glog
, bzip2, openldap, readline, libelf, uwimap, binutils, cyrus_sasl, pam, libpng
, libxslt, ocaml
}:

stdenv.mkDerivation rec {
  name    = "hhvm-${version}";
  version = "3.1.0";

  src = fetchgit {
    url    = "https://github.com/facebook/hhvm.git";
    rev    = "71ecbd8fb5e94b2a008387a2b5e9a8df5c6f5c7b";
    sha256 = "1zv3k3bxahwyna2jgicwxm9lxs11jddpc9v41488rmzvfhdmzzkn";
    fetchSubmodules = true;
  };

  buildInputs =
    [ cmake boost libunwind mariadb libmemcached pcre libevent gd curl
      libxml2 icu flex bison openssl zlib php expat libcap oniguruma
      libdwarf libmcrypt tbb gperftools bzip2 openldap readline
      libelf uwimap binutils cyrus_sasl pam glog libpng libxslt ocaml
    ];

  enableParallelBuilding = true;
  dontUseCmakeBuildDir = true;
  dontUseCmakeConfigure = true;
  NIX_LDFLAGS = "-lpam -L${pam}/lib";
  USE_HHVM=1;
  MYSQL_INCLUDE_DIR="${mariadb}/include/mysql";
  MYSQL_DIR=mariadb;

  patchPhase = ''
    substituteInPlace hphp/util/generate-buildinfo.sh \
      --replace /bin/bash ${stdenv.shell}
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
