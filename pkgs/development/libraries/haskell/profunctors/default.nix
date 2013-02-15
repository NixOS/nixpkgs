{ cabal, comonad, tagged }:

cabal.mkDerivation (self: {
  pname = "profunctors";
  version = "3.3";
  sha256 = "0cvar0qr2yf0lmqwhiy2ibajiq9cmqy2ikwn8l5mdxxh5q5rwgjj";
  buildDepends = [ comonad tagged ];
  meta = {
    homepage = "http://github.com/ekmett/profunctors/";
    description = "Haskell 98 Profunctors";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
