{cabal, text, blazeBuilder}:

cabal.mkDerivation (self : {
  pname = "blaze-html";
  version = "0.4.1.4";
  sha256 = "1xf302dapwmmlxj9alfbdv6rcrxhr9p305s4jz2d6ckq2xzz8yjf";
  propagatedBuildInputs = [text blazeBuilder];
  meta = {
    description = "A blazingly fast HTML combinator library";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})
