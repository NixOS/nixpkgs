{ cabal }:

cabal.mkDerivation (self: {
  pname = "date-cache";
  version = "0.3.0";
  sha256 = "0grhcbd0rhdn0cf1fz82x8pv8cmxfhndlcwyrax4mnnr3pql9kmb";
  meta = {
    description = "Date cacher";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
