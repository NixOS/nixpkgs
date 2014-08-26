{ cabal, fetchgit, ghcjsBase, mtl }:

cabal.mkDerivation (self: {
  pname = "ghcjs-dom";
  version = "0.1.0.0";
  src = fetchgit {
    url = git://github.com/ghcjs/ghcjs-dom.git;
    rev = "81805e75ccd41501774b90c04efd9e00d52e9798";
    sha256 = "3aa56fb81974533661aa056ed080edab29bef8ab26dae61999de4452f95949f6";
  };

  buildDepends = [ ghcjsBase mtl ];
  meta = {
    description = "DOM library that supports both GHCJS and WebKitGTK";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
