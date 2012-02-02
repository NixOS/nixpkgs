{ cabal, dataObject, monadControl, neither, persistent, text
, transformers
}:

cabal.mkDerivation (self: {
  pname = "persistent-sqlite";
  version = "0.6.2.1";
  sha256 = "10sqmkd7vnrrpr8phcswbxcvn8vjipgy96nk2jj3g96j3cfwfpk0";
  buildDepends = [
    dataObject monadControl neither persistent text transformers
  ];
  meta = {
    homepage = "http://www.yesodweb.com/book/persistent";
    description = "Backend for the persistent library using sqlite3";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
