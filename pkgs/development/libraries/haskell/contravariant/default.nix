{ cabal, tagged, transformers, transformersCompat }:

cabal.mkDerivation (self: {
  pname = "contravariant";
  version = "0.6";
  sha256 = "031kwn2hpw25p2q0bhfgby0ihxjbcyv6w0v0nsj2zygif9jkfrrh";
  buildDepends = [ tagged transformers transformersCompat ];
  meta = {
    homepage = "http://github.com/ekmett/contravariant/";
    description = "Contravariant functors";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
