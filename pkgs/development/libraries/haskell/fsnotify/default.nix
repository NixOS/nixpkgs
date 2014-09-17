{ stdenv, cabal, async, hinotify, hfsevents, systemFileio, systemFilepath
, tasty, tastyHunit, temporaryRc, text, time
}:

cabal.mkDerivation (self: {
  pname = "fsnotify";
  version = "0.1.0.3";
  sha256 = "0m6jyg45azk377jklgwyqrx95q174cxd5znpyh9azznkh09wq58z";
  buildDepends = [ async systemFileio systemFilepath text time ] ++
    (if stdenv.isDarwin then [ hfsevents ] else [ hinotify ]);
  testDepends = [
    async systemFileio systemFilepath tasty tastyHunit temporaryRc
  ];
  doCheck = false;
  meta = {
    description = "Cross platform library for file change notification";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
