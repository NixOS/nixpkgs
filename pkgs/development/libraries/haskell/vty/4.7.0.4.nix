{cabal, deepseq, mtl, parallel, parsec, terminfo, utf8String,
 vector} :

cabal.mkDerivation (self : {
  pname = "vty";
  version = "4.7.0.4";
  sha256 = "1rwki3ch1r3dqzb1cxmzxn05k49ams64licl0silbhsj3qibbj53";
  propagatedBuildInputs = [
    deepseq mtl parallel parsec terminfo utf8String vector
  ];
  meta = {
    homepage = "https://github.com/coreyoconnor/vty";
    description = "A simple terminal access library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
