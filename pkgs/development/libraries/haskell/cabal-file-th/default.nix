{ cabal }:

cabal.mkDerivation (self: {
  pname = "cabal-file-th";
  version = "0.1";
  sha256 = "1i0k8c9kf2av0vs9qhd15kqrkzi5z89va4gp2cfkssq66y98k8p8";
  meta = {
    homepage = "http://github.com/nkpart/cabal-file-th";
    description = "Template Haskell expressions for reading fields from a project's cabal file";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
