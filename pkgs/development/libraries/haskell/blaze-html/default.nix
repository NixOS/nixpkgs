{cabal, text}:

cabal.mkDerivation (self : {
  pname = "blaze-html";
  version = "0.1.2";
  sha256 = "c1e65e3d23e90a3830ceee69ecfac65c7a8a045da06443fb7690609a59480f5f";
  propagatedBuildInputs = [text];
  meta = {
    description = "A blazingly fast HTML combinator library";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})
