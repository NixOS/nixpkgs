{ cabal, filepath, mtl, parsec, syb, WebBits, WebBitsHtml }:

cabal.mkDerivation (self: {
  pname = "JsContracts";
  version = "0.5.3";
  sha256 = "17l6kdpdc7lrpd9j4d2b6vklkpclshcjy6hzpi442b7pj96sn589";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ filepath mtl parsec syb WebBits WebBitsHtml ];
  meta = {
    homepage = "http://www.cs.brown.edu/research/plt/";
    description = "Design-by-contract for JavaScript";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
