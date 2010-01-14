{cabal, mtl}:

cabal.mkDerivation (self : {
  pname = "QuickCheck";
  version = "2.1.0.2";
  sha256 = "1adeea5aa52cba7b8bcd27f9cdd9fe944e9a4a22d22fdf0570b526f580981e58";
  propagatedBuildInputs = [mtl];
  meta = {
    description = "Automatic testing of Haskell programs";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

