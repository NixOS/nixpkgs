{ 
  stdenv, fetchurl, perl, ghc, binary, zlib, utf8String, readline, fgl,
  regexCompat, HsSyck, random
}:

stdenv.mkDerivation rec {

  name = "jhc-${version}";

  version = "0.8.0";

  src = fetchurl {
    url = "http://repetae.net/dist/${name}.tar.gz";
    sha256 = "0rbv0gpp7glhd9xqy7snbiaiizwnsfg9vzhvyywcvbmb35yivy2a";
  };

  buildInputs = [
    perl ghc binary zlib utf8String readline fgl regexCompat HsSyck random
  ];

  meta = {
    description = ''
      A Haskell compiler which aims to produce the most efficient programs
    '';
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.aforemny ];
  };

}
