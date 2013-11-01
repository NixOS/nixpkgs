{ cabal, lua, mtl }:

cabal.mkDerivation (self: {
  pname = "hslua";
  version = "0.3.8";
  sha256 = "1yb23cyb3wj70z8lvk6w2sn13kc17v53fd8m587kb4fpqzpdz44d";
  buildDepends = [ mtl ];
  pkgconfigDepends = [ lua ];
  configureFlags = "-fsystem-lua";
  meta = {
    description = "A Lua language interpreter embedding in Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
