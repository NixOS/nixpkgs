{ cabal, Cabal }:

cabal.mkDerivation (self: {
  pname = "utility-ht";
  version = "0.0.7.1";
  sha256 = "0k097kyv6rxjvg1drnphv2mg882xx2lk098hs557fcsr16w658ma";
  buildDepends = [ Cabal ];
  meta = {
    description = "Various small helper functions for Lists, Maybes, Tuples, Functions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
