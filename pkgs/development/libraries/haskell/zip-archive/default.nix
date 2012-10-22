{ cabal, binary, digest, filepath, mtl, time, utf8String, zlib }:

cabal.mkDerivation (self: {
  pname = "zip-archive";
  version = "0.1.2.1";
  sha256 = "1c0pjbrkfv44nbpz60b1c4xdbkdk8qaxlkfxl51rb2183gj1gkph";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ binary digest filepath mtl time utf8String zlib ];
  meta = {
    homepage = "http://github.com/jgm/zip-archive";
    description = "Library for creating and modifying zip archives";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
