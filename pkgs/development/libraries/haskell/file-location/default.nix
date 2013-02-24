{ cabal, liftedBase, transformers }:

cabal.mkDerivation (self: {
  pname = "file-location";
  version = "0.4.5.2";
  sha256 = "0dyzf2lhh0n4hwbh44qfh6bw9snl4hha9sv76c4ndi7v1rvnx197";
  buildDepends = [ liftedBase transformers ];
  testDepends = [ liftedBase transformers ];
  meta = {
    homepage = "https://github.com/gregwebs/FileLocation.hs";
    description = "common functions that show file location information";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
