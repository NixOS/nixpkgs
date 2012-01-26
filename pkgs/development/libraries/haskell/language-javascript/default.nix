{ cabal, alex, happy, mtl, utf8Light }:

cabal.mkDerivation (self: {
  pname = "language-javascript";
  version = "0.4.6";
  sha256 = "1rqbb44cyvj6iyipi4bzrdd59lk9q1vxh0zvilvc54kqg97y07v6";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ mtl utf8Light ];
  buildTools = [ alex happy ];
  meta = {
    homepage = "http://github.com/alanz/language-javascript";
    description = "Parser for JavaScript";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
