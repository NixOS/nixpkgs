{cabal, text, blazeBuilder}:

cabal.mkDerivation (self : {
  pname = "blaze-html";
  version = "0.4.1.0";
  sha256 = "0a39wzfsb8lsr0z8c0s90n6pwmhjg6lihbxigk2c02vn5marzc4f";
  propagatedBuildInputs = [text blazeBuilder];
  meta = {
    description = "A blazingly fast HTML combinator library";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})
