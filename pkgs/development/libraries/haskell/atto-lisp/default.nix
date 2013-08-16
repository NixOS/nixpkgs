{ cabal, attoparsec, blazeBuilder, blazeTextual, deepseq, text }:

cabal.mkDerivation (self: {
  pname = "atto-lisp";
  version = "0.2.1.1";
  sha256 = "089chx4g880fbs7gh1mcvfx2xgbqdi1dxdjax6vbw8xiqgw4pzac";
  jailbreak = true;
  buildDepends = [
    attoparsec blazeBuilder blazeTextual deepseq text
  ];
  meta = {
    homepage = "http://github.com/nominolo/atto-lisp";
    description = "Efficient parsing and serialisation of S-Expressions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
