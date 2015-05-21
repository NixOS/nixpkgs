{ stdenv, fetchurl, xz }:

stdenv.mkDerivation rec {
  name = "libunwind-1.1";
  
  src = fetchurl {
    url = "mirror://savannah/libunwind/${name}.tar.gz";
    sha256 = "16nhx2pahh9d62mvszc88q226q5lwjankij276fxwrm8wb50zzlx";
  };

  patches = [ ./libunwind-1.1-lzma.patch ];

  postPatch = ''
    sed -i -e '/LIBLZMA/s:-lzma:-llzma:' configure
  '';

  propagatedBuildInputs = [ xz ];

  NIX_CFLAGS_COMPILE = if stdenv.system == "x86_64-linux" then "-fPIC" else "";
  preInstall = ''
    mkdir -p "$out/lib"
    touch "$out/lib/libunwind-generic.so"
  '';
  
  meta = with stdenv.lib; {
    homepage = http://www.nongnu.org/libunwind;
    description = "A portable and efficient API to determine the call-chain of a program";
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
