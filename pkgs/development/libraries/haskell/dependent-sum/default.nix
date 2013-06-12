{ cabal }:

cabal.mkDerivation (self: {
  pname = "dependent-sum";
  version = "0.2.0.1";
  sha256 = "07zv8rj574vf7wl3pms4q8d9m7zsfppac5vla9d9b7q11s81lldf";
  meta = {
    homepage = "https://github.com/mokus0/dependent-sum";
    description = "Dependent sum type";
    license = self.stdenv.lib.licenses.publicDomain;
    platforms = self.ghc.meta.platforms;
  };
})
