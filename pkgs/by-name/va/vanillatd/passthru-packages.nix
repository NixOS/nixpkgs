{
  lib,
  stdenvNoCC,
  unar,
  appName,
  fetchurl,
  ...
}:
builtins.mapAttrs
  (
    name: buildCommand:
    stdenvNoCC.mkDerivation {
      inherit name buildCommand;
      nativeBuildInputs = [ unar ];
      meta = {
        sourceProvenance = with lib.sourceTypes; [
          binaryBytecode
        ];
        license = with lib.licenses; [
          unfree
        ];
      };
    }
  )
  (
    if appName == "vanillatd" then
      let
        CCDEMO1_ZIP = fetchurl {
          url = "https://archive.org/download/CommandConquerDemo/cc1demo1.zip";
          hash = "sha256-KdM4SctFCocmJCbMWbJbql4DO5TC40leyU+BPzvAn4c=";
        };
        CCDEMO2_ZIP = fetchurl {
          url = "https://archive.org/download/CommandConquerDemo/cc1demo2.zip";
          hash = "sha256-pCgEuE5AFcJur3qUOTmP3GCb/Wp7p7JyVn8Yeq17PEg=";
        };
        demo = ''
          unar -no-directory ${CCDEMO1_ZIP} DEMO.MIX DEMOL.MIX SOUNDS.MIX SPEECH.MIX
          unar -no-directory ${CCDEMO2_ZIP} DEMOM.MIX
          mkdir -p $out
          mv DEMO.MIX $out/demo.mix
          mv DEMOL.MIX $out/demol.mix
          mv SOUNDS.MIX $out/sounds.mix
          mv SPEECH.MIX $out/speech.mix
          mv DEMOM.MIX $out/demom.mix
        '';
      in
      # see https://github.com/TheAssemblyArmada/Vanilla-Conquer/wiki/Installing-VanillaTD
      {
        inherit demo;
      }
    else if appName == "vanillara" then
      let
        RA95DEMO_ZIP = fetchurl {
          url = "https://archive.org/download/CommandConquerRedAlert_1020/ra95demo.zip";
          hash = "sha256-jEi9tTUj6k01OnkU2SNM5OPm9YMu60eztrAFhT6HSNI=";
        };
        demo = ''
          unar -no-directory ${RA95DEMO_ZIP} ra95demo/INSTALL/MAIN.MIX ra95demo/INSTALL/REDALERT.MIX
          install -D ra95demo/INSTALL/REDALERT.MIX $out/redalert.mix
          install -D ra95demo/INSTALL/MAIN.MIX $out/main.mix
        '';
        REDALERT_ALLIED_ISO = fetchurl {
          url = "https://archive.org/download/cnc-red-alert/redalert_allied.iso";
          hash = "sha256-Npx6hSTJetFlcb/Fi3UQEGuP0iLk9LIrRmAI7WgEtdw=";
        };
        REDALERT_SOVIETS_ISO = fetchurl {
          url = "https://archive.org/download/cnc-red-alert/redalert_soviets.iso";
          hash = "sha256-aJGr+w1BaGaLwX/pU0lMmu6Cgn9pZ2D/aVafBdtds2Q=";
        };
        retail-allied = ''
          unar -output-directory allied -no-directory ${REDALERT_ALLIED_ISO} MAIN.MIX INSTALL/REDALERT.MIX
          mkdir -p $out/allied/
          mv allied/INSTALL/REDALERT.MIX $out/redalert.mix
          mv allied/MAIN.MIX $out/allied/main.mix
        '';
        retail-soviet = ''
          unar -output-directory soviet -no-directory ${REDALERT_SOVIETS_ISO} MAIN.MIX INSTALL/REDALERT.MIX
          mkdir -p $out/soviet/
          mv soviet/INSTALL/REDALERT.MIX $out/redalert.mix
          mv soviet/MAIN.MIX $out/soviet/main.mix
        '';
        retail = ''
          unar -output-directory allied -no-directory ${REDALERT_ALLIED_ISO} MAIN.MIX INSTALL/REDALERT.MIX
          unar -output-directory soviet -no-directory ${REDALERT_SOVIETS_ISO} MAIN.MIX
          mkdir -p $out/allied/ $out/soviet/
          mv allied/INSTALL/REDALERT.MIX $out/redalert.mix
          mv allied/MAIN.MIX $out/allied/main.mix
          mv soviet/MAIN.MIX $out/soviet/main.mix
        '';
      in
      # see https://github.com/TheAssemblyArmada/Vanilla-Conquer/wiki/Installing-VanillaRA
      {
        inherit
          demo
          retail-allied
          retail-soviet
          retail
          ;
      }
    else
      { }
  )
