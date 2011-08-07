{cabal, blazeBuilder, text, vector} :

cabal.mkDerivation (self : {
  pname = "blaze-textual";
  version = "0.1.0.0";
  sha256 = "0ql25b0r4xbshqsjfndl7glq0hp2ncxb3h5zd541vsqrqrf8y4gk";
  propagatedBuildInputs = [ blazeBuilder text vector ];
  meta = {
    homepage = "http://github.com/mailrank/blaze-textual";
    description = "Fast rendering of common datatypes";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.stdenv.lib.platforms.haskellPlatforms;
    maintainers = [
      self.stdenv.lib.maintainers.simons
      self.stdenv.lib.maintainers.andres
    ];
  };
})
