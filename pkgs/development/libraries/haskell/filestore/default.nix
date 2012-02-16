{ cabal, Cabal, Diff, filepath, parsec, split, time, utf8String
, xml
}:

cabal.mkDerivation (self: {
  pname = "filestore";
  version = "0.4.0.4";
  sha256 = "14rp2689gjnk9pqk2xv4m3q3icgfvbik32c2d6gx4l2y7n78dsbx";
  buildDepends = [
    Cabal Diff filepath parsec split time utf8String xml
  ];
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
