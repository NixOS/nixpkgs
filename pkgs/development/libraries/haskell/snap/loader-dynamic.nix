{ cabal, directoryTree, hint, mtl, snapCore, time }:

cabal.mkDerivation (self: {
  pname = "snap-loader-dynamic";
  version = "0.9.0";
  sha256 = "1pbpvi20an077klvha1dflnlxpfb6m81n9d50hjhidf6430cmmhm";
  buildDepends = [ directoryTree hint mtl snapCore time ];
  meta = {
    homepage = "http://snapframework.com/";
    description = "Snap: A Haskell Web Framework: dynamic loader";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
