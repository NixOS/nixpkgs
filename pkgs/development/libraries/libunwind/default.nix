{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "libunwind-1.0.1";
  
  src = fetchurl {
    url = "http://download.savannah.nongnu.org/releases/libunwind/${name}.tar.gz";
    sha256 = "aa95fd184c0b90d95891c2f3bac2c7df708ff016d2a6ee8b2eabb769f864101f";
  };
  
  NIX_CFLAGS_COMPILE = if stdenv.system == "x86_64-linux" then "-fPIC" else "";
  preInstall = ''
    mkdir -p "$out/lib"
    touch "$out/lib/libunwind-generic.so"
  '';
  
  meta = {
    homepage = http://www.nongnu.org/libunwind;
    description = "A portable and efficient API to determine the call-chain of a program";
  };
}
