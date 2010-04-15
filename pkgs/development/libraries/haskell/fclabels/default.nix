{cabal, monadsFd}:

cabal.mkDerivation (self : {
  pname = "fclabels";
  version = "0.4.2";
  sha256 = "d1abfd94f8970e55ed839645a58697b8beeacc5e5ea4a5861001539aa8fc28d7";
  propagatedBuildInputs = [monadsFd];
  meta = {
    description = "First class accessor labels";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

