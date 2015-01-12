{ pkgs }:

rec {

  overrideCabal = drv: f: drv.override (args: args // {
    mkDerivation = drv: args.mkDerivation (drv // f drv);
  });

  doHaddock = drv: overrideCabal drv (drv: { noHaddock = false; });
  dontHaddock = drv: overrideCabal drv (drv: { noHaddock = true; });

  doJailbreak = drv: overrideCabal drv (drv: { jailbreak = true; });
  dontJailbreak = drv: overrideCabal drv (drv: { jailbreak = false; });

  doCheck = drv: overrideCabal drv (drv: { doCheck = true; });
  dontCheck = drv: overrideCabal drv (drv: { doCheck = false; });

  dontDistribute = drv: overrideCabal drv (drv: { hydraPlatforms = []; });

  appendConfigureFlag = drv: x: overrideCabal drv (drv: { configureFlags = (drv.configureFlags or []) ++ [x]; });
  removeConfigureFlag = drv: x: overrideCabal drv (drv: { configureFlags = pkgs.stdenv.lib.remove x (drv.configureFlags or []); });

  enableCabalFlag = drv: x: appendConfigureFlag (removeConfigureFlag drv "-f-${x}") "-f${x}";
  disableCabalFlag = drv: x: appendConfigureFlag (removeConfigureFlag drv "-f${x}") "-f-${x}";

}
