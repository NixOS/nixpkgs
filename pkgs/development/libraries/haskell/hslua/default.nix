{ cabal, lua, mtl }:

cabal.mkDerivation (self: {
  pname = "hslua";
  version = "0.3.10";
  sha256 = "1d79sp9xmzbq74jk7kj81j0z4vm813fkkxkpbyzg07x649i6q0v2";
  buildDepends = [ mtl ];
  pkgconfigDepends = [ lua ];
  configureFlags = "-fsystem-lua";
  meta = {
    description = "A Lua language interpreter embedding in Haskell";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
