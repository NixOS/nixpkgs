{ cabal, aeson, syb }:

cabal.mkDerivation (self: {
  pname = "pandoc-types";
  version = "1.12.3";
  sha256 = "1klfplpn2faw9da7xw5h5sx44annc2g7himyzyvb436wjnkjan0j";
  buildDepends = [ aeson syb ];
  meta = {
    homepage = "http://johnmacfarlane.net/pandoc";
    description = "Types for representing a structured document";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
