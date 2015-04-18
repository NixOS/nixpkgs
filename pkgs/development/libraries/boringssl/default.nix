{ stdenv, fetchgit, cmake, perl }:

stdenv.mkDerivation rec {
  name = "boringssl-${version}";
  version = "20140820-a7d1363f";

  src = fetchgit {
    url    = "https://boringssl.googlesource.com/boringssl";
    rev    = "a7d1363fcb1f0d825ec2393c06be3d58b0c57efd";
    sha256 = "d27dd1416de1a2ea4ec2c219248b2ed2cce5c0405e56adb394077ddc7c319bab";
  };

  buildInputs = [ cmake perl ];
  enableParallelBuilding = true;
  NIX_CFLAGS_COMPILE = "-Wno-error=cpp";

  installPhase = ''
    mkdir -p $out/bin $out/include $out/lib

    mv tool/bssl    $out/bin
    mv ssl/libssl.a $out/lib
    mv ../include/openssl $out/include
  '';

  meta = {
    description = "Free TLS/SSL implementation";
    homepage    = "https://boringssl.googlesource.com";
    platforms   = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
