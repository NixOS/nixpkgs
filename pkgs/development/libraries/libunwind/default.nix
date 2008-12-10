{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "libunwind-0.98.6";
  
  src = fetchurl {
    url = "http://download.savannah.nongnu.org/releases/libunwind/${name}.tar.gz";
    sha256 = "1qfxqkyx4r5dmwajyhvsyyl8zwxs6n2rcg7a61fgfdfp0gxvpzgx";
  };
  
  configureFlags = "--enable-shared --disable-static";

  NIX_CFLAGS_COMPILE = if stdenv.system == "x86_64-linux" then "-fPIC" else "";
  
  meta = {
    homepage = http://www.nongnu.org/libunwind;
    description = "A portable and efficient API to determine the call-chain of a program";
  };
}
