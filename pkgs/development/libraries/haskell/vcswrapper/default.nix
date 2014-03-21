{ cabal, filepath, hxt, MissingH, mtl, parsec }:

cabal.mkDerivation (self: {
  pname = "vcswrapper";
  version = "0.0.3";
  sha256 = "04gmiiv461qh8fypkkiynipn5jsjqvywkj17ldq5wag4qaspx97x";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ filepath hxt MissingH mtl parsec ];
  meta = {
    homepage = "https://github.com/forste/haskellVCSWrapper";
    description = "Wrapper for source code management systems";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
  };
})
