{ cabal, attoparsec, attoparsecConduit, binary, blazeBuilder
, conduit, doctest, hspec, iproute, mtl, network, networkConduit
, random
}:

cabal.mkDerivation (self: {
  pname = "dns";
  version = "1.2.0";
  sha256 = "1pzwvb1qycjw6qw34xhd4ap9jl0cc79d3i09b23bg0vqcz80vmpr";
  buildDepends = [
    attoparsec attoparsecConduit binary blazeBuilder conduit iproute
    mtl network networkConduit random
  ];
  testDepends = [
    attoparsec attoparsecConduit binary blazeBuilder conduit doctest
    hspec iproute mtl network networkConduit random
  ];
  testTarget = "spec";
  meta = {
    description = "DNS library in Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
