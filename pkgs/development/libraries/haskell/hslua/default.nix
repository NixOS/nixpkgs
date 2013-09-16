{ cabal, mtl }:

cabal.mkDerivation (self: {
  pname = "hslua";
  version = "0.3.6.1";
  sha256 = "0c60gnf0mp6kx2z2149icl7hdwvigibvxd091a3vc6zkl5c5r41p";
  buildDepends = [ mtl ];
  meta = {
    description = "A Lua language interpreter embedding in Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
