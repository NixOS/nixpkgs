{cabal, deepseq}:

cabal.mkDerivation (self : {
  pname = "text";
  version = "0.7.2.1";
  sha256 = "13b00db1363219e263a4af5b1318d2a296d67c975883cd7e17265fcd8fb1381c";
  propagatedBuildInputs = [deepseq];
  meta = {
    description = "An efficient package Unicode text type";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

