{ cabal, binary, Cabal, digest, filepath, mtl, utf8String, zlib }:

cabal.mkDerivation (self: {
  pname = "zip-archive";
  version = "0.1.1.7";
  sha256 = "1q52v18kl1j049kk3yb7rp0k27p6q7r72mg1vcbdid6qd7a9dh48";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    binary Cabal digest filepath mtl utf8String zlib
  ];
  meta = {
    homepage = "http://github.com/jgm/zip-archive";
    description = "Library for creating and modifying zip archives";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
