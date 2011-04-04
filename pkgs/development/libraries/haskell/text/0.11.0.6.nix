{cabal, deepseq}:

cabal.mkDerivation (self : {
  pname = "text";
  version = "0.11.0.6"; # Haskell Platform 2011.2.0.1
  sha256 = "103l1c8jfwpddsqzwj9jqh89vay8ax1znxqgjqprv2fvr7s0zvkp";
  propagatedBuildInputs = [deepseq];
  meta = {
    description = "An efficient package Unicode text type";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

