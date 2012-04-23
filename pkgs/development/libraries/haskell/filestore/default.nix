{ cabal, Diff, filepath, HUnit, mtl, parsec, split, time
, utf8String, xml
}:

cabal.mkDerivation (self: {
  pname = "filestore";
  version = "0.4.2";
  sha256 = "1zv5c1r82a77p6dadabj8853a0z7p8qrk0fdxvr9sr02zd95cg16";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    Diff filepath HUnit mtl parsec split time utf8String xml
  ];
  meta = {
    homepage = "http://johnmacfarlane.net/repos/filestore";
    description = "Interface for versioning file stores";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
