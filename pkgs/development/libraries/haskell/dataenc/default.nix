{ cabal }:

cabal.mkDerivation (self: {
  pname = "dataenc";
  version = "0.14.0.2";
  sha256 = "1zym24259d053b7vbxir2l7229gilkg81vvc0wf9605873j6gw5b";
  isLibrary = true;
  isExecutable = true;
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Library/Data_encoding";
    description = "Data encoding library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
