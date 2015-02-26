{ cabal, ansiWlPprint, cmdargs, haskeline, parsec, QuickCheck,
  testFramework, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "hatt";
  version = "1.5.0.3";
  sha256 = "0dgjia07v489wlk23hg84d1043rh71hl9yg7vdcih2jcj8pn00z4";
  buildDepends = [
    ansiWlPprint cmdargs haskeline parsec 
  ];
  testDepends = [ QuickCheck testFramework testFrameworkQuickcheck2 ];
  meta = {
    homepage = "http://extralogical.net/projects/hatt";
    description = "classical propositional logic library";
    license = self.stdenv.lib.licenses.bsd3;
  };
})
