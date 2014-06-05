{ cabal, deepseq, mtl, tasty, tastyHunit, tastyQuickcheck, time }:

cabal.mkDerivation (self: {
  pname = "hourglass";
  version = "0.2.0";
  sha256 = "13zphy3gfj9p7vsa477qy30968fnz5kq7d0lzb1pyg5hxkx44rim";
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
