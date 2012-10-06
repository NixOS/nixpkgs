{ cabal, network }:

cabal.mkDerivation (self: {
  pname = "simple-sendfile";
  version = "0.2.8";
  sha256 = "11lw8m21cy40hd9nzp80d9jawgv9hd3sfvizjcfbvdc2lpq6m17j";
  buildDepends = [ network ];
  meta = {
    description = "Cross platform library for the sendfile system call";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
