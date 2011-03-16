{cabal, alex, happy}:

cabal.mkDerivation (self : {
  pname = "gtk2hs-buildtools";
  version = "0.12.0";
  sha256 = "1czlmyr9zhzc0h1j0z3chv06ma77cibq2yc6h1slfphb1lkv66a8";
  extraBuildInputs = [alex happy];
  meta = {
    description = "Tools to build the Gtk2Hs suite of User Interface libraries";
    license = "GPL";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})
