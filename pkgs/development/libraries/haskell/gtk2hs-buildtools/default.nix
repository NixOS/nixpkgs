{cabal, alex, happy}:

cabal.mkDerivation (self : {
  pname = "gtk2hs-buildtools";
  version = "0.11.2";
  sha256 = "330c52830358966bcff308f58a570e84bb0b4d6004b6f01107d55dd88faa54ad";
  extraBuildInputs = [alex happy];
  meta = {
    description = "Tools to build the Gtk2Hs suite of User Interface libraries";
    license = "GPL";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})
