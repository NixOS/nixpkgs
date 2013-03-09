{ cabal, HUnit, stm }:

cabal.mkDerivation (self: {
  pname = "SafeSemaphore";
  version = "0.9.0";
  sha256 = "1xa30cciw8wmri675kdsz4pb5qwrh592pzylbhawqsvsarf80gz4";
  buildDepends = [ stm ];
  testDepends = [ HUnit ];
  meta = {
    homepage = "https://github.com/ChrisKuklewicz/SafeSemaphore";
    description = "Much safer replacement for QSemN, QSem, and SampleVar";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
