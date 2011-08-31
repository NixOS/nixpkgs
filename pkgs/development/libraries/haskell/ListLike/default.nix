{ cabal }:

cabal.mkDerivation (self: {
  pname = "ListLike";
  version = "3.1.2";
  sha256 = "1fa2y8yc0ppmh37alc20a75gpb90i8s3pgnh3kg8n0577gvhjhzz";
  isLibrary = true;
  isExecutable = true;
  meta = {
    homepage = "http://software.complete.org/listlike";
    description = "Generic support for list-like structures";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
