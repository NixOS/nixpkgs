{ cabal, bindingsSophia, tasty, tastyHunit, cabalBounds }:

cabal.mkDerivation (self: {
  pname = "sophia";
  version = "0.1.2";
  sha256 = "18svfy0ald8cz03vfv3m43w777rxksmaz0713a1vzcmyfb6h5iwg";
  buildDepends = [ bindingsSophia ];
  testDepends = [ bindingsSophia tasty tastyHunit ];
  preConfigure = ''
    # jailbreak=true produces an syntax error in the cabal file
    ${cabalBounds}/bin/cabal-bounds drop sophia.cabal
  '';
  meta = {
    description = "Bindings to Sophia library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
