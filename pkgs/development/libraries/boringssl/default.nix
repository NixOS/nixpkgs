{ stdenv, fetchgit, cmake, perl, go }:

stdenv.mkDerivation rec {
  name = "boringssl-${version}";
  version = "2016-03-08";

  src = fetchgit {
    url    = "https://boringssl.googlesource.com/boringssl";
    rev    = "bfb38b1a3c5e37d43188bbd02365a87bebc8d122";
    sha256 = "0bm7vqg3bk716xmw2af99p44zizfhknq9z3cphf7klfdrr7ibqm5";
  };

  buildInputs = [ cmake perl go ];
  enableParallelBuilding = true;
  NIX_CFLAGS_COMPILE = "-Wno-error";

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
