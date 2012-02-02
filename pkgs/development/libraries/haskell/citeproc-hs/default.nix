{ cabal, hsBibutils, HTTP, json, mtl, network, pandocTypes, parsec
, syb, time, utf8String, xml
}:

cabal.mkDerivation (self: {
  pname = "citeproc-hs";
  version = "0.3.4";
  sha256 = "17w6fpmlhbfd8jxxz4s6ybz3dswf0i96fjjbs05ykh4i97rs62nv";
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
