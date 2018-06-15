{ stdenv, fetchgit, cmake, perl, go }:

# reference: https://boringssl.googlesource.com/boringssl/+/2661/BUILDING.md
stdenv.mkDerivation rec {
  name = "boringssl-${version}";
  version = "2017-02-23";

  src = fetchgit {
    url    = "https://boringssl.googlesource.com/boringssl";
    rev    = "be2ee342d3781ddb954f91f8a7e660c6f59e87e5";
    sha256 = "022zq7wlkhrg6al7drr3555lam3zw5bb10ylf9mznp83s854f975";
  };

  buildInputs = [ cmake perl go ];
  enableParallelBuilding = true;
  NIX_CFLAGS_COMPILE = "-Wno-error";

  installPhase = ''
    mkdir -p $out/bin $out/include $out/lib

    mv tool/bssl $out/bin

    mv ssl/libssl.a           $out/lib
    mv crypto/libcrypto.a     $out/lib
    mv decrepit/libdecrepit.a $out/lib

    mv ../include/openssl $out/include
  '';

  meta = {
    description = "Free TLS/SSL implementation";
    homepage    = "https://boringssl.googlesource.com";
    platforms   = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
