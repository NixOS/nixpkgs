{ cabal, nats, semigroups, terminfo, text, transformers
, wlPprintExtras
}:

cabal.mkDerivation (self: {
  pname = "wl-pprint-terminfo";
  version = "3.6";
  sha256 = "14dq0inv6i8pwjzrpys420iwi6002mard1n73z96k89zq5xhwlbg";
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
