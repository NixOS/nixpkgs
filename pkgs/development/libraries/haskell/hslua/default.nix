{ cabal, lua, mtl }:

cabal.mkDerivation (self: {
  pname = "hslua";
  version = "0.3.9";
  sha256 = "0rs9hfc1k7wihgvp6vizccwppv5nd9mszp7a2y7pwjrprapwj07c";
  buildDepends = [ mtl ];
  pkgconfigDepends = [ lua ];
  configureFlags = "-fsystem-lua";
  meta = {
    description = "A Lua language interpreter embedding in Haskell";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
