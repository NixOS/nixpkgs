{ cabal, comonad, contravariant, distributive, semigroups
, transformers
}:

cabal.mkDerivation (self: {
  pname = "semigroupoids";
  version = "4.0.1";
  sha256 = "0w4r4nmyq94aq9xlyvrankipfwdmlcz2ghqicn9drqfjirhi8lrl";
  buildDepends = [
    comonad contravariant distributive semigroups transformers
  ];
  meta = {
    homepage = "http://github.com/ekmett/semigroupoids";
    description = "Semigroupoids: Category sans id";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
