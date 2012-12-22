{ cabal, directoryTree, hint, mtl, snapCore, time }:

cabal.mkDerivation (self: {
  pname = "snap-loader-dynamic";
  version = "0.10";
  sha256 = "0wnrsbnf3crfxhhraz4my08m6yhmqj632rv6cdy9ili3wxjkqd57";
  buildDepends = [ directoryTree hint mtl snapCore time ];
  meta = {
    homepage = "http://snapframework.com/";
    description = "Snap: A Haskell Web Framework: dynamic loader";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
