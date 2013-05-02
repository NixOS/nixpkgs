{ cabal, cmdargs, filepath, haskeline, hledgerLib, HUnit, mtl
, parsec, regexpr, safe, shakespeareText, split, text, time
, utf8String
}:

cabal.mkDerivation (self: {
  pname = "hledger";
  version = "0.20";
  sha256 = "1jdh01y8jys1ha3qrmx509ka4wb1bgv28xz3rwz8aklz2nfzn4zb";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    cmdargs filepath haskeline hledgerLib HUnit mtl parsec regexpr safe
    shakespeareText split text time utf8String
  ];
  meta = {
    homepage = "http://hledger.org";
    description = "The main command-line interface for the hledger accounting tool";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
