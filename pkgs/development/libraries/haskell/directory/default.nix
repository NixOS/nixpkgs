{ cabal, filepath, time }:

cabal.mkDerivation (self: {
  pname = "directory";
  version = "1.2.1.0";
  sha256 = "110ch0nd2hh5fsq3whrvj85s0h27ch1q6xg7z9s6mqbd6k6p9yzs";
  buildDepends = [ filepath time ];
  meta = {
    description = "library for directory handling";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
