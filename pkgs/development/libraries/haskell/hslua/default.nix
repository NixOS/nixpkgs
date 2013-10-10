{ cabal, lua, mtl }:

cabal.mkDerivation (self: {
  pname = "hslua";
  version = "0.3.7";
  sha256 = "1q5s2b7x9idvdvp31yl86mmy476gfq6rg8f0r8faqxrm45jwgv2q";
  buildDepends = [ mtl ];
  pkgconfigDepends = [ lua ];
  configureFlags = "-fsystem-lua";
  meta = {
    description = "A Lua language interpreter embedding in Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
