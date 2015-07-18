{ stdenv, fetchgit, cmake, perl, go }:

stdenv.mkDerivation rec {
  name = "boringssl-${version}";
  version = "20150713-7f15ff53";

  src = fetchgit {
    url    = "https://boringssl.googlesource.com/boringssl";
    rev    = "7f15ff53d82a1991d6732d2303eb652b1cf7e023";
    sha256 = "0c48vf6wcqm26lyn03f72yw3l1wng02zw1pjya1d1vqld7s0bdxq";
  };

  buildInputs = [ cmake perl go ];
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
