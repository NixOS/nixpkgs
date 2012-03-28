{ cabal, mtl }:

cabal.mkDerivation (self: {
  pname = "Shellac";
  version = "0.9.5.1";
  sha256 = "19fpbh5ijy9xc3rhl9qwyan8jfnz9nsqvnsjxb7kkb7l2bpz4qfp";
  buildDepends = [ mtl ];
  meta = {
    homepage = "http://www.cs.princeton.edu/~rdockins/shellac/home/";
    description = "A framework for creating shell envinronments";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
