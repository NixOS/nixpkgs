{ stdenv, fetchurl, fetchgit, cmake, boost, libunwind, mysql, libmemcached, pcre
, libevent, gd, curl, libxml2, icu, flex, bison, openssl, zlib, php, re2c
, expat, libcap, oniguruma, libdwarf, libmcrypt, inteltbb, gperftools, glog
, bzip2, openldap, readline, libelf, uwimap, binutils, cyrus_sasl, pam, libpng
}:
assert stdenv.system == "x86_64-linux";
let
  src = fetchgit {
    url = "git://github.com/facebook/hiphop-php.git";
    rev = "1e23dec9f0b1ce8aaa5833d0527a369c8e254ffd";
    sha256 = "0fblwgq8c3hmamw0m5d1mn8qhyqf14v2zf62cgrkvmbiz6jlrbr6";
  };

  libxml2_280 = stdenv.lib.overrideDerivation libxml2 (args: rec { 
    name = "libxml2-2.8.0";

    src = fetchurl {
      url = "ftp://xmlsoft.org/libxml2/${name}.tar.gz";
      sha256 = "0ak2mjwvanz91nwxf1kkgbhrkm85vhhkpj7ymz8r6lb84bix1qpj";
    };

    patches = [];
  });

  fbPatch = "${src}/hphp/third_party/libevent-1.4.14.fb-changes.diff";

  libeventFB = stdenv.lib.overrideDerivation libevent (args: { patches = [fbPatch]; });
in
stdenv.mkDerivation {
  name = "hiphop-php-1e23dec9f0";
  inherit src;
  dontUseCmakeBuildDir = true;
  dontUseCmakeConfigure = true;
  USE_HHVM=1;
  preConfigure = ''
    export HPHP_LIB=$PWD/bin
    export TBB_INSTALL_DIR=${inteltbb}
    export TBB_ARCH_PLATFORM="intel64/cc4.1.0_libc2.4_kernel2.6.16.21"
    sed 's=/bin/bash=/${stdenv.shell}=g' -i hphp/util/generate-buildinfo.sh
  '';
  NIX_LDFLAGS = "-lpam -L${pam}/lib";
  MYSQL_INCLUDE_DIR="${mysql}/include/mysql";
  MYSQL_DIR=mysql;
  buildInputs = [ 
    cmake boost libunwind mysql libmemcached pcre libeventFB gd curl
    libxml2_280 icu flex bison openssl zlib php expat libcap oniguruma
    libdwarf libmcrypt inteltbb gperftools bzip2 openldap readline
    libelf uwimap binutils cyrus_sasl pam glog libpng
  ];
  installPhase = ''
    mkdir -p $out/bin
    cp hphp/hhvm/hhvm $out/bin
  '';
  patches = [./tbb.patch];

  meta = {
    description = "High performance PHP toolchain";
    homepage = https://github.com/facebook/hiphop-php;
    platforms = ["x86_64-linux"];
  };
}
