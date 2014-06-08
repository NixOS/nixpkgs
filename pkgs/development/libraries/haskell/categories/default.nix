{ cabal, void }:

cabal.mkDerivation (self: {
  pname = "categories";
  version = "1.0.6";
  sha256 = "0i5mrxbhqj5g46lvwbw2m07prjvfwja6q8648qm6bq54z6zrl5cy";
  buildDepends = [ void ];
  meta = {
    homepage = "http://github.com/ekmett/categories";
    description = "Categories";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
