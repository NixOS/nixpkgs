{ cabal, syb }:

cabal.mkDerivation (self: {
  pname = "pandoc-types";
  version = "1.10";
  sha256 = "1xbqvgb95h0jhqx2y0jzds3xvycx5gwi3xn6agdmfkg7xhx9hnz6";
  buildDepends = [ syb ];
  meta = {
    homepage = "http://johnmacfarlane.net/pandoc";
    description = "Types for representing a structured document";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
