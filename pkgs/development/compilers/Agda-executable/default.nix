{cabal, Agda}:

cabal.mkDerivation (self : {
  pname = "Agda-executable";
  name = self.fname;
  version = "2.2.10";
  sha256 = "0jjlbz5vaz1pasfws1cy8wvllzdzv3sxm2lfj6bckl93kdrxlpy6";
  propagatedBuildInputs = [Agda];
  meta = {
    description = "Command-line program for type-checking and compiling Agda programs";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})
