{ cabal, transformers, transformersCompat }:

cabal.mkDerivation (self: {
  pname = "contravariant";
  version = "0.3";
  sha256 = "025rmangj0g8vls1ymh1dz4xq6ljnn8fsbcfrds3030s325v4zl9";
  buildDepends = [ transformers transformersCompat ];
  meta = {
    homepage = "http://github.com/ekmett/contravariant/";
    description = "Haskell 98 contravariant functors";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
