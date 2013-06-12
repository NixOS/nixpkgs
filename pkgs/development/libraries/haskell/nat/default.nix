{ cabal }:

cabal.mkDerivation (self: {
  pname = "nat";
  version = "0.3";
  sha256 = "1v43c1dr72qn8mymnwcq6an8sqxjaxhac037k4gbv8z8bg18zmf5";
  meta = {
    description = "Lazy binary natural numbers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
