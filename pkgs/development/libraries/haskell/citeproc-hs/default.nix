{ cabal, hsBibutils, HTTP, json, mtl, network, pandocTypes, parsec
, syb, time, utf8String, xml
}:

cabal.mkDerivation (self: {
  pname = "citeproc-hs";
  version = "0.3.3";
  sha256 = "0yhzqxrr7jn1h0r2vy1jmlrf0z64qcr2fl37i04rpiwzb3nc16r4";
  buildDepends = [
    hsBibutils HTTP json mtl network pandocTypes parsec syb time
    utf8String xml
  ];
  meta = {
    homepage = "http://gorgias.mine.nu/repos/citeproc-hs/";
    description = "A Citation Style Language implementation in Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
