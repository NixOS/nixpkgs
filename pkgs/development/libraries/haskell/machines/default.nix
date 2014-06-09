{ cabal, comonad, doctest, filepath, free, mtl, pointed
, profunctors, semigroups, transformers, void
}:

cabal.mkDerivation (self: {
  pname = "machines";
  version = "0.2.5";
  sha256 = "0745lhmfwq27nna517q7b82q59pda587wgh6840nw65syaj2qfhp";
  buildDepends = [
    comonad free mtl pointed profunctors semigroups transformers void
  ];
  testDepends = [ doctest filepath ];
  meta = {
    homepage = "http://github.com/ekmett/machines/";
    description = "Networked stream transducers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
