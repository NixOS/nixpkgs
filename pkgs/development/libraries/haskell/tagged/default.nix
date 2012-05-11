{ cabal }:

cabal.mkDerivation (self: {
  pname = "tagged";
  version = "0.4.2.1";
  sha256 = "0acd0wyyl6nx8i6r5h6smb7apmnmic6kn7ks9pc8nfmhlzhgfk57";
  meta = {
    homepage = "http://github.com/ekmett/tagged";
    description = "Haskell 98 phantom types to avoid unsafely passing dummy arguments";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
