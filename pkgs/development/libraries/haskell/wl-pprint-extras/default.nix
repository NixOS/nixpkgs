{ cabal, nats, semigroupoids, semigroups, text, utf8String }:

cabal.mkDerivation (self: {
  pname = "wl-pprint-extras";
  version = "3.4";
  sha256 = "17vxyckx2pj4sc2d1yw1rcsxn1rp4nzdjp0hgpy78xsp9plccgsy";
  buildDepends = [ nats semigroupoids semigroups text utf8String ];
  meta = {
    homepage = "http://github.com/ekmett/wl-pprint-extras/";
    description = "A free monad based on the Wadler/Leijen pretty printer";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
