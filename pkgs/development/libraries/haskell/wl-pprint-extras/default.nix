{ cabal, HUnit, nats, semigroupoids, semigroups, testFramework
, testFrameworkHunit, text, utf8String
}:

cabal.mkDerivation (self: {
  pname = "wl-pprint-extras";
  version = "3.5";
  sha256 = "172xp23j3w8jbd7h0sna9g8p4d6xwy8154gqj93ycz2907r2kwb7";
  buildDepends = [ nats semigroupoids semigroups text utf8String ];
  testDepends = [ HUnit testFramework testFrameworkHunit ];
  meta = {
    homepage = "http://github.com/ekmett/wl-pprint-extras/";
    description = "A free monad based on the Wadler/Leijen pretty printer";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
