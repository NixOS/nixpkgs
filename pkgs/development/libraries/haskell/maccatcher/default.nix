{ cabal, binary, parsec }:

cabal.mkDerivation (self: {
  pname = "maccatcher";
  version = "2.1.5";
  sha256 = "0z56rbfr8vijhjf3dcqd4kaxgx9bf3qgi9sm61yc3i6ra60w7byb";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ binary parsec ];
  meta = {
    description = "Obtain the host MAC address on *NIX and Windows";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
