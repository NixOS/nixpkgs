{ cabal, lenses, mtl, transformers, uuInterleaved, uuParsinglib }:

cabal.mkDerivation (self: {
  pname = "uu-options";
  version = "0.1.0.1";
  sha256 = "0dygg4w3rlnf1pnmwq7i6vzz0v90b4g18ipfc5whn1ss1bixwxk4";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    lenses mtl transformers uuInterleaved uuParsinglib
  ];
  meta = {
    homepage = "http://www.cs.uu.nl/wiki/bin/view/HUT/ParserCombinators";
    description = "Parse command line options using uu-interleave and uu-parsinglib";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
