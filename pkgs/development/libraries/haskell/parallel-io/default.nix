{ cabal, extensibleExceptions, random }:

cabal.mkDerivation (self: {
  pname = "parallel-io";
  version = "0.3.2.1";
  sha256 = "0wrmz0i5s8p87840pacdnpf2fi12nips4yc72vymifrc1wvlc42q";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ extensibleExceptions random ];
  meta = {
    homepage = "http://batterseapower.github.com/parallel-io";
    description = "Combinators for executing IO actions in parallel on a thread pool";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
