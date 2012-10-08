{ cabal, directoryTree, hint, mtl, snapCore, time }:

cabal.mkDerivation (self: {
  pname = "snap-loader-dynamic";
  version = "0.9.0.1";
  sha256 = "1pzn8lfqngn8cqm1dpxn5wsx70xcd7r90rd2948n4p5309qgh9mq";
  buildDepends = [ directoryTree hint mtl snapCore time ];
  meta = {
    homepage = "http://snapframework.com/";
    description = "Snap: A Haskell Web Framework: dynamic loader";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
