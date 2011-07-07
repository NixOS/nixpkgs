{cabal, aeson, blazeTextual, hamlet, text, vector, yesodCore}:

cabal.mkDerivation (self : {
  pname = "yesod-json";
  version = "0.1.1.1";
  sha256 = "02mly02c6z49s0gznx47w919gcn7qz1qvr8704sab1sjk87cyjwl";
  propagatedBuildInputs = [
    aeson blazeTextual hamlet text vector yesodCore
  ];
  meta = {
    description = "Generate content for Yesod using the aeson package";
    license = "BSD3";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

