{ cabal, directoryTree, hint, mtl, snapCore, time }:

cabal.mkDerivation (self: {
  pname = "snap-loader-dynamic";
  version = "0.10.0.2";
  sha256 = "0fnpzhwnj3dsqwx880391x9x6y0ry8f6dfrzkfs963zib9l3qvh7";
  buildDepends = [ directoryTree hint mtl snapCore time ];
  meta = {
    homepage = "http://snapframework.com/";
    description = "Snap: A Haskell Web Framework: dynamic loader";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
