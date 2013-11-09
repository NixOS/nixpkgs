{ cabal, hashtables, syb, utf8String }:

cabal.mkDerivation (self: {
  pname = "HsSyck";
  version = "0.51";
  sha256 = "13y5vbzrix33dzwhdrvng2ds2dnipkxn1h22jvbf47rwnkyh2g49";
  buildDepends = [ hashtables syb utf8String ];
  meta = {
    description = "Fast, lightweight YAML loader and dumper";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
