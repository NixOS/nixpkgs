{cabal, alex, happy}:

cabal.mkDerivation (self : {
  pname = "gtk2hs-buildtools";
  version = "0.9";
  sha256 = "2586c419394601c1840d827d32cdb9d76bc94d71c03fdfa23c8d04cba99c6b20";
  extraBuildInputs = [alex happy];
  meta = {
    description = "Tools to build the Gtk2Hs suite of User Interface libraries";
    license = "GPL";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})
