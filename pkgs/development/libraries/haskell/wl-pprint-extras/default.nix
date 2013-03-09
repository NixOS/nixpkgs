{ cabal, nats, semigroupoids, semigroups, utf8String }:

cabal.mkDerivation (self: {
  pname = "wl-pprint-extras";
  version = "3.3";
  sha256 = "1q3wiw62k53yl9ny9l54b281zprrnshw94pd52rlcxbw9cgj8xzx";
  buildDepends = [ nats semigroupoids semigroups utf8String ];
  meta = {
    homepage = "http://github.com/ekmett/wl-pprint-extras/";
    description = "A free monad based on the Wadler/Leijen pretty printer";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
