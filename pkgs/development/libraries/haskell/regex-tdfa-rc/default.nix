{ cabal, mtl, parsec, regexBase }:

cabal.mkDerivation (self: {
  pname = "regex-tdfa-rc";
  version = "1.1.8.3";
  sha256 = "1vi11i23gkkjg6193ak90g55akj69bhahy542frkwb68haky4pp3";
  buildDepends = [ mtl parsec regexBase ];
  meta = {
    homepage = "http://hackage.haskell.org/package/regex-tdfa";
    description = "Replaces/Enhances Text.Regex";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
