{ cabal, Diff, filepath, parsec, split, time, utf8String, xml }:

cabal.mkDerivation (self: {
  pname = "filestore";
  version = "0.4.1";
  sha256 = "02ki6b4rbmk463qmmqia7igkrsr7h1kxal94k6pikkikylx2f8r7";
  buildDepends = [ Diff filepath parsec split time utf8String xml ];
  meta = {
    homepage = "http://johnmacfarlane.net/repos/filestore";
    description = "Interface for versioning file stores";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
