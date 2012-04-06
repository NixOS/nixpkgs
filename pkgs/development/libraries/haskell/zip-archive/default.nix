{ cabal, binary, digest, filepath, mtl, utf8String, zlib }:

cabal.mkDerivation (self: {
  pname = "zip-archive";
  version = "0.1.1.8";
  sha256 = "0rq4jk1sxi6lrc7d7sh500lh83v2fxxrfh2gknqiyzxd3wh364y1";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ binary digest filepath mtl utf8String zlib ];
  meta = {
    homepage = "http://github.com/jgm/zip-archive";
    description = "Library for creating and modifying zip archives";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
