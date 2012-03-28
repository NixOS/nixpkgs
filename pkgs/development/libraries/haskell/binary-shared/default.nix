{ cabal, binary, mtl }:

cabal.mkDerivation (self: {
  pname = "binary-shared";
  version = "0.8.1";
  sha256 = "0niq6hgsawsdg3kkjgkwyrgy8w7pfkqfph5d1x5bzcjrcl982jrg";
  buildDepends = [ binary mtl ];
  meta = {
    homepage = "http://www.leksah.org";
    description = "Sharing for the binary package";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
