{ cabal, dlist }:

cabal.mkDerivation (self: {
  pname = "data-default";
  version = "0.4.0";
  sha256 = "1pil8dxbk0zl2zw1xj9h2bpwpdriwfd7aj48kh0xpw9yazg3m802";
  buildDepends = [ dlist ];
  meta = {
    description = "A class for types with a default value";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
