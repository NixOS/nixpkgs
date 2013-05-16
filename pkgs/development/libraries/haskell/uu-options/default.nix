{ cabal, lenses, mtl, transformers, uuInterleaved, uuParsinglib }:

cabal.mkDerivation (self: {
  pname = "uu-options";
  version = "0.1.0.0";
  sha256 = "08z465w0naw8hx831bcgqbwmp9zdmw3bq4i7rgz7zfzb088nfwzc";
  isLibrary = true;
  buildDepends = [
    lenses mtl transformers uuInterleaved uuParsinglib
  ];
  patchFlags = "-p0";
  patches = [ ./no-executable-stanza.diff ];
  meta = {
    homepage = "http://www.cs.uu.nl/wiki/bin/view/HUT/ParserCombinators";
    description = "Parse command line options using uu-interleave and uu-parsinglib";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
