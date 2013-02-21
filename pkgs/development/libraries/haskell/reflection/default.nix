{ cabal, tagged }:

cabal.mkDerivation (self: {
  pname = "reflection";
  version = "1.1.7";
  sha256 = "073v9y09fvh7nsfqp1jp2ncrq0xkcv5fvikl769ghv2ycgkfxl4z";
  buildDepends = [ tagged ];
  meta = {
    homepage = "http://github.com/ekmett/reflection";
    description = "Reifies arbitrary terms into types that can be reflected back into terms";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
