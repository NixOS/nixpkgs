{ cabal, directoryTree, hint, mtl, snapCore, time }:

cabal.mkDerivation (self: {
  pname = "snap-loader-dynamic";
  version = "0.10.0.1";
  sha256 = "0iqhspvfp0d6qivis2l3v0rqrnb8qbzvi4n53zgyb9cwvqxx5fix";
  buildDepends = [ directoryTree hint mtl snapCore time ];
  meta = {
    homepage = "http://snapframework.com/";
    description = "Snap: A Haskell Web Framework: dynamic loader";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
