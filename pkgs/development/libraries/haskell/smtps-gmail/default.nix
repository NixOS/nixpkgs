{ cabal, base64String, cprngAes, network, tlsExtra, utf8String
}:

cabal.mkDerivation (self: {
  pname = "smtps-gmail";
  version = "1.0.0";
  sha256 = "0kv5m8rg5z1iic10av3bscdygnph1iab4b22sq3hmx6a93abqkc2";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    base64String cprngAes network tlsExtra utf8String
  ];
  meta = {
    homepage = "https://github.com/enzoh/smtps-gmail";
    description = "Gmail API";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
  # adding a Setup script as it's needed by nix
  preConfigure = ''
    printf "import Distribution.Simple\nmain = defaultMain\n" > Setup.hs
  '';
})
