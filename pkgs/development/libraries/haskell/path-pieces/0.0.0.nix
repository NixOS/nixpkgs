{ cabal, text }:

cabal.mkDerivation (self: {
  pname = "path-pieces";
  version = "0.0.0";
  sha256 = "09sk4wlzy37gaii7spisjy4a3pizis9si4kv389bki20gfwpaivf";
  buildDepends = [ text ];
  meta = {
    homepage = "http://github.com/snoyberg/path-pieces";
    description = "Components of paths";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
