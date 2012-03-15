{ cabal, hashable, primitive, vector }:

cabal.mkDerivation (self: {
  pname = "hashtables";
  version = "1.0.1.3";
  sha256 = "1ad8psza13ff15sd4s862sryw6z8msiys1f7frnp4sibgr6bwdca";
  buildDepends = [ hashable primitive vector ];
  meta = {
    homepage = "http://github.com/gregorycollins/hashtables";
    description = "Mutable hash tables in the ST monad";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
