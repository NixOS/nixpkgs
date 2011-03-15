{cabal}:

cabal.mkDerivation (self : {
  pname = "AC-Vector";
  version = "2.3.1";
  sha256 = "0nmj57czqcik23j9iqxbdwqg73n5n1kc9akhp0wywrbkklgf79a0";
  meta = {
    description = "Efficient geometric vectors and transformations";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

