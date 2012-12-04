{ stdenv, fetchurl, fetchgit, cmake, boost, libunwind, mysql, libmemcached, pcre
, libevent, gd, curl, libxml2, icu, flex, bison, openssl, zlib, php, re2c
, expat, libcap, oniguruma, libdwarf, libmcrypt, inteltbb, google_perftools
, bzip2, openldap, readline, libelf, uwimap, binutils, cyrus_sasl, pam
}:
assert stdenv.system == "x86_64-linux";
let
  src = fetchgit {
    url = "git://github.com/facebook/hiphop-php.git";
    rev = "73f1c0ebd9b313f6b3baecd8c8046e0b595b1157";
    sha256 = "104133c6054bc9ab0288eaa0cea168b6699e537b3ea76ecdc38ee833d93dca09";
  };

  libxml2_280 = stdenv.lib.overrideDerivation libxml2 (args: rec { 
    name = "libxml2-2.8.0";

    src = fetchurl {
      url = "ftp://xmlsoft.org/libxml2/${name}.tar.gz";
      sha256 = "0ak2mjwvanz91nwxf1kkgbhrkm85vhhkpj7ymz8r6lb84bix1qpj";
    };

    patches = [];
  });
 
  curlFB = stdenv.lib.overrideDerivation curl (args: { patches = [ "${src}/src/third_party/libcurl-7.22.1.fb-changes.diff" ]; });

  fbPatch = "${src}/src/third_party/libevent-1.4.14.fb-changes.diff";
  libeventFB = stdenv.lib.overrideDerivation libevent (args: { patches = [fbPatch]; });
in
stdenv.mkDerivation {
  name = "hiphop-php-73f1c0ebd9";
  inherit src;
  dontUseCmakeBuildDir = true;
  dontUseCmakeConfigure = true;
  USE_HHVM=1;
  preConfigure = ''
    export HPHP_HOME=$PWD
    export HPHP_LIB=$PWD/bin
    export TBB_INSTALL_DIR=${inteltbb}
    export TBB_ARCH_PLATFORM="intel64/cc4.1.0_libc2.4_kernel2.6.16.21"
    sed -i 's| DEPRECATED | DEPRECATED_ |' src/runtime/base/runtime_error.h
  '';
  NIX_LDFLAGS = "-lpam -L${pam}/lib";
  MYSQL_DIR=mysql;
  buildInputs = [ 
    cmake boost libunwind mysql libmemcached pcre libeventFB gd curlFB
    libxml2_280 icu flex bison openssl zlib php expat libcap oniguruma
    libdwarf libmcrypt inteltbb google_perftools bzip2 openldap readline
    libelf uwimap binutils cyrus_sasl pam
  ];
  installPhase = ''
    mkdir -p $out/bin
    cp src/hhvm/hhvm $out/bin
    cp bin/systemlib.php $out/bin
  '';
  patches = [./tbb.patch];

  meta = {
    description = "HipHop is a high performance PHP toolchain.";
    homepage = https://github.com/facebook/hiphop-php;
    platforms = ["x86_64-linux"];
  };
}
