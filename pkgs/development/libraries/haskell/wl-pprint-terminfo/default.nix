{ cabal, nats, semigroups, terminfo, text, transformers
, wlPprintExtras
}:

cabal.mkDerivation (self: {
  pname = "wl-pprint-terminfo";
  version = "3.7";
  sha256 = "01lzk8wfynb98ks8a0gvj8qffi50zlfaywlc9axr6j7h8rrblnm3";
  buildDepends = [
    nats semigroups terminfo text transformers wlPprintExtras
  ];
  meta = {
    homepage = "http://github.com/ekmett/wl-pprint-terminfo/";
    description = "A color pretty printer with terminfo support";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
