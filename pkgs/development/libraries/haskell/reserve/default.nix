{ cabal, baseCompat, hspec, httpConduit, httpKit, httpTypes
, network, QuickCheck, warp
}:

cabal.mkDerivation (self: {
  pname = "reserve";
  version = "0.0.0";
  sha256 = "06rj1dh8lsfbmfkslyhqc031abrz2qw780i8w2c5pc146938pdi3";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ baseCompat httpKit httpTypes network ];
  testDepends = [
    baseCompat hspec httpConduit httpKit httpTypes network QuickCheck
    warp
  ];
  meta = {
    description = "Reserve reloads web applications";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
