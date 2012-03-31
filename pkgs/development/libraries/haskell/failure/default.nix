{ cabal, transformers }:

cabal.mkDerivation (self: {
  pname = "failure";
  version = "0.2.0.1";
  sha256 = "05k62sb2xj4ddjwsbfldxkap7v5kmv04qzic4sszx5i3ykbf20fd";
  buildDepends = [ transformers ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Failure";
    description = "A simple type class for success/failure computations";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
