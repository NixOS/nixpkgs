{ cabal, zlib }:

cabal.mkDerivation (self: {
  pname = "zlib-bindings";
  version = "0.0.1";
  sha256 = "0m8q155yyrd4q1ddfmmhdx88mg1875ywrlr484qwpcyd58gn3bkv";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ zlib ];
  meta = {
    homepage = "http://github.com/snoyberg/zlib-bindings";
    description = "Low-level bindings to the zlib package";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
