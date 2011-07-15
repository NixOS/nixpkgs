{cabal, blazeBuilder, text, vector}:

cabal.mkDerivation (self : {
  pname = "blaze-textual";
  version = "0.1.0.0";
  sha256 = "0ql25b0r4xbshqsjfndl7glq0hp2ncxb3h5zd541vsqrqrf8y4gk";
  propagatedBuildInputs = [blazeBuilder text vector];
  meta = {
    description = "Fast rendering of common datatypes";
    license = "BSD3";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

