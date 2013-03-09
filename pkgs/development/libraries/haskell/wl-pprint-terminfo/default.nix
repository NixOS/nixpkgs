{ cabal, nats, semigroups, terminfo, transformers, wlPprintExtras
}:

cabal.mkDerivation (self: {
  pname = "wl-pprint-terminfo";
  version = "3.4";
  sha256 = "1wnlm74fwcn171a533bv15bvlhabrzh192wabala0wyvwgl8hwzk";
  buildDepends = [
    nats semigroups terminfo transformers wlPprintExtras
  ];
  meta = {
    homepage = "http://github.com/ekmett/wl-pprint-terminfo/";
    description = "A color pretty printer with terminfo support";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
