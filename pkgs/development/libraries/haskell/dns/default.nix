{ cabal, attoparsec, attoparsecConduit, binary, blazeBuilder
, conduit, iproute, mtl, network, networkConduit, random
}:

cabal.mkDerivation (self: {
  pname = "dns";
  version = "0.3.6";
  sha256 = "0dpwy94id9rxxjpji47nazinm8i1ihm0606dmi5iqqhbl5h2jara";
  buildDepends = [
    attoparsec attoparsecConduit binary blazeBuilder conduit iproute
    mtl network networkConduit random
  ];
  meta = {
    description = "DNS library in Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
