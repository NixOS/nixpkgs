{ cabal, cabalFileTh, cmdargs, filepath, haskeline, hledgerLib
, HUnit, mtl, parsec, regexpr, safe, shakespeareText, split, text
, time, utf8String
}:

cabal.mkDerivation (self: {
  pname = "hledger";
  version = "0.18";
  sha256 = "15jbfq9a1lydn0m998vzrx4nlpfkbv5ddvj6h03hljp562f2s0wi";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    cabalFileTh cmdargs filepath haskeline hledgerLib HUnit mtl parsec
    regexpr safe shakespeareText split text time utf8String
  ];
  meta = {
    homepage = "http://hledger.org";
    description = "The main command-line interface for the hledger accounting tool";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
