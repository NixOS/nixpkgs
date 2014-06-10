{ cabal, deepseq, mtl, tasty, tastyHunit, tastyQuickcheck, time }:

cabal.mkDerivation (self: {
  pname = "hourglass";
  version = "0.2.1";
  sha256 = "0xb5g10mm427yagv5hzg5wgxpjjr6s9my675ik8rh5k1is4zr500";
  buildDepends = [ deepseq ];
  testDepends = [
    deepseq mtl tasty tastyHunit tastyQuickcheck time
  ];
  meta = {
    homepage = "https://github.com/vincenthz/hs-hourglass";
    description = "simple performant time related library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
