{cabal, parsec} :

cabal.mkDerivation (self : {
  pname = "wxdirect";
  version = "0.12.1.4";
  sha256 = "0v1blh3l02h58cvsngfax5knmg51lil1kj6pr5iqrbcrivp2nh7f";
  propagatedBuildInputs = [ parsec ];
  meta = {
    homepage = "http://haskell.org/haskellwiki/WxHaskell";
    description = "helper tool for building wxHaskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
