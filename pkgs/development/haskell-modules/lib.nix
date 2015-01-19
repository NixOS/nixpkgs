{ pkgs }:

rec {

  overrideCabal = drv: f: (drv.override (args: args // {
    mkDerivation = drv: args.mkDerivation (drv // f drv);
  })) // {
    overrideScope = scope: overrideCabal (drv.overrideScope scope) f;
  };

  doHaddock = drv: overrideCabal drv (drv: { doHaddock = true; });
  dontHaddock = drv: overrideCabal drv (drv: { doHaddock = false; });

  doJailbreak = drv: overrideCabal drv (drv: { jailbreak = true; });
  dontJailbreak = drv: overrideCabal drv (drv: { jailbreak = false; });

  doCheck = drv: overrideCabal drv (drv: { doCheck = true; });
  dontCheck = drv: overrideCabal drv (drv: { doCheck = false; });

  dontDistribute = drv: overrideCabal drv (drv: { hydraPlatforms = []; });

  appendConfigureFlag = drv: x: overrideCabal drv (drv: { configureFlags = (drv.configureFlags or []) ++ [x]; });
  removeConfigureFlag = drv: x: overrideCabal drv (drv: { configureFlags = pkgs.stdenv.lib.remove x (drv.configureFlags or []); });

  enableCabalFlag = drv: x: appendConfigureFlag (removeConfigureFlag drv "-f-${x}") "-f${x}";
  disableCabalFlag = drv: x: appendConfigureFlag (removeConfigureFlag drv "-f${x}") "-f-${x}";

  markBroken = drv: overrideCabal (drv: { broken = true; });

  enableLibraryProfiling = drv: overrideCabal drv (drv: { enableLibraryProfiling = true; });
  disableLibraryProfiling = drv: overrideCabal drv (drv: { enableLibraryProfiling = false; });

  enableSharedExecutables = drv: overrideCabal drv ( { enableSharedExecutables = true; });
  disableSharedExecutables = drv: overrideCabal drv ( { enableSharedExecutables = false; });

  enableSharedLibraries = drv: overrideCabal drv (drv: { enableSharedLibraries = true; });
  disableSharedLibraries = drv: overrideCabal drv (drv: { enableSharedLibraries = false; });

  enableSplitObjs = drv: overrideCabal drv (drv: { enableSplitObjs = true; });
  disableSplitObjs = drv: overrideCabal drv (drv: { enableSplitObjs = false; });

  enableStaticLibraries = drv: overrideCabal drv (drv: { enableStaticLibraries = true; });
  disableStaticLibraries = drv: overrideCabal drv (drv: { enableStaticLibraries = false; });

}
