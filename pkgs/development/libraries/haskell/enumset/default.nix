{ cabal, dataAccessor, storableRecord }:

cabal.mkDerivation (self: {
  pname = "enumset";
  version = "0.0.4";
  sha256 = "1dzwxi7i757zdf68v470n8dwn1g8kg51w3c1mwqyxwq85650805w";

  isExecutable = false;
  isLibrary = true;

  buildDepends = [
    dataAccessor
    storableRecord
  ];

  meta = {
    description = "Sets of enumeration values represented by machine words";
    license     = self.stdenv.lib.licenses.bsd3;
    platforms   = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ertes];
  };

})
