{ cabal, cabalInstall, Cabal, alex, ansiTerminal, deepseq, executablePath
, filepath, graphSCC, happy, haskeline, monadLib, mtl, presburger, QuickCheck
, random, smtLib, syb, text, transformers, utf8String, process, fetchgit
}:

cabal.mkDerivation (self: {
  pname = "cryptol";
  version = "2.0.0";
  src = fetchgit {
    url    = "https://github.com/GaloisInc/cryptol.git";
    rev    = "refs/tags/v2.0.0";
    sha256 = "6af3499d7c6f034446f6665660f7a66dd592e81281e34b0cee3e55bc03597e6b";
  };
  isLibrary = true;
  isExecutable = true;

  patches = [ ./fix-gitrev.patch ];
  buildDepends = [
    ansiTerminal deepseq executablePath filepath graphSCC haskeline
    monadLib mtl presburger QuickCheck random smtLib syb text
    transformers utf8String process Cabal
  ];
  buildTools = [ alex happy cabalInstall ];
  meta = {
    description = "Cryptol: The Language of Cryptography";
    homepage    = "https://cryptol.net";
    license     = self.stdenv.lib.licenses.bsd3;
    platforms   = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.thoughtpolice ];
  };
})
