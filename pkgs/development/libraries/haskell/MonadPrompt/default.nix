{cabal, mtl}:

cabal.mkDerivation (self : {
  pname = "MonadPrompt";
  version = "1.0.0.2";
  sha256 = "01inbw0lfjrsgs68fvak1rxi76nhwsiyarfwl1g5mis4glmh4w4c";
  propagatedBuildInputs = [mtl];
  preConfigure = ''
    sed -i 's|base<=4|base >= 3 \&\& < 5|' ${self.pname}.cabal
  '';
  meta = {
    description = "MonadPrompt, implementation & examples";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

