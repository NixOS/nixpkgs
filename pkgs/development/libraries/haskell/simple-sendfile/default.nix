{ cabal, network }:

cabal.mkDerivation (self: {
  pname = "simple-sendfile";
  version = "0.2.2";
  sha256 = "0id3d6ynl2xz4w0vcxm3wyj1kxjnchcl3h0xa4prh3s0giap8yax";
  buildDepends = [ network ];
  meta = {
    description = "Cross platform library for the sendfile system call";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
