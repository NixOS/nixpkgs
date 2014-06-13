{ cabal, deepseq, mtl, tasty, tastyHunit, tastyQuickcheck, time }:

cabal.mkDerivation (self: {
  pname = "hourglass";
  version = "0.2.2";
  sha256 = "015ipy9adi67nfddjsw9c0ihn0banghgawjli0lgrmiyjz01610c";
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
