{ cabal, network }:

cabal.mkDerivation (self: {
  pname = "simple-sendfile";
  version = "0.2.4";
  sha256 = "1c7imvkb5aq5mlg6a1r36fp9klniicbj56n32yvzj4qqf1zy2pbx";
  buildDepends = [ network ];
  meta = {
    description = "Cross platform library for the sendfile system call";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
