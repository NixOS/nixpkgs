{ stdenv, fetchurl, perl, ghc, binary, zlib, utf8String, readline, fgl,
  regexCompat, HsSyck, random }:

stdenv.mkDerivation rec {
  name = "jhc-${version}";
  version = "0.8.2";

  src = fetchurl {
    url    = "http://repetae.net/dist/${name}.tar.gz";
    sha256 = "0lrgg698mx6xlrqcylba9z4g1f053chrzc92ri881dmb1knf83bz";
  };

  buildInputs =
    [ perl ghc binary zlib utf8String
      readline fgl regexCompat HsSyck random
    ];

  meta = {
    description = "Whole-program, globally optimizing Haskell compiler";
    homepage = "http://repetae.net/computer/jhc/";
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers;
      [ aforemny simons thoughtpolice ];
  };
}
