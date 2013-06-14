{ cabal, cairo, Chart, colour, dataAccessor, dataAccessorTemplate
, gtk, mtl, time
}:

cabal.mkDerivation (self: {
  pname = "Chart-gtk";
  version = "0.17";
  sha256 = "1i411kdpz75azyhfaryazr0bpij5xcl0y82m9a7k23w8mhybqwc7";
  buildDepends = [
    cairo Chart colour dataAccessor dataAccessorTemplate gtk mtl time
  ];
  meta = {
    homepage = "https://github.com/timbod7/haskell-chart/wiki";
    description = "Utility functions for using the chart library with GTK";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
