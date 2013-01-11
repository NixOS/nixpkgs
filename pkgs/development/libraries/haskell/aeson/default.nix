{ cabal, attoparsec, blazeBuilder, deepseq, dlist, hashable, mtl
, syb, text, time, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "aeson";
  version = "0.6.1.0";
  sha256 = "16hjwcybmgmk1sg8x02r9bxisx4gl61rlq8w2zsxfgkxwjpfhkbx";
  buildDepends = [
    attoparsec blazeBuilder deepseq dlist hashable mtl syb text time
    unorderedContainers vector
  ];
  meta = {
    homepage = "https://github.com/bos/aeson";
    description = "Fast JSON parsing and encoding";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
