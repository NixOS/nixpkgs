{ cabal, Cabal, deepseq, mtl, parallel, parsec, QuickCheck, random
, stringQq, terminfo, utf8String, vector
}:

cabal.mkDerivation (self: {
  pname = "vty";
  version = "4.7.5";
  sha256 = "0ahd5qjszfw1xbl5jxhzfw31mny8hp8clw9qciv15xn442prvvpr";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    deepseq mtl parallel parsec stringQq terminfo utf8String vector
  ];
  testDepends = [
    Cabal deepseq mtl parallel parsec QuickCheck random terminfo
    utf8String vector
  ];
  jailbreak = true;
  doCheck = false;
  meta = {
    homepage = "https://github.com/coreyoconnor/vty";
    description = "A simple terminal UI library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
