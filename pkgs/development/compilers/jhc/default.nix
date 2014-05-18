{ stdenv, fetchurl, perl, ghc, binary, zlib, utf8String, readline, fgl,
  regexCompat, HsSyck, random }:

stdenv.mkDerivation rec {
  name = "jhc-${version}";
  version = "0.8.1";

  src = fetchurl {
    url = "http://repetae.net/dist/${name}.tar.gz";
    sha256 = "11fya5ggk6q4vcm3kwjacfaaqvkammih25saqwlr1g40bcikbnf2";
  };

  patchPhase = ''
    substituteInPlace ./src/Util/Interact.hs \
      --replace USE_NOLINE USE_READLINE
  '';

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
