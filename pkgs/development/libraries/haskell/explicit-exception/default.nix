{ cabal, Cabal, transformers }:

cabal.mkDerivation (self: {
  pname = "explicit-exception";
  version = "0.1.6";
  sha256 = "0pgdbaav952bwcmbfwg0fgvc15k57rlnw131bs3pnp8rqdbxfv39";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ Cabal transformers ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Exception";
    description = "Exceptions which are explicit in the type signature";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
