{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  npmHooks,
  pnpm_9,
  fetchPnpmDeps,
  pnpmConfigHook,
  systemdMinimal,
  nixosTests,
  nix-update-script,
  withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemdMinimal,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "zigbee2mqtt";
  version = "2.9.2";

  src = fetchFromGitHub {
    owner = "Koenkk";
    repo = "zigbee2mqtt";
    tag = finalAttrs.version;
    hash = "sha256-LdrsHOeRXeNccpf1UNg20y82M75PGt070zVbmQYYsVg=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_9;
    fetcherVersion = 1;
    hash = "sha256-8ioe9/gSI9u9ehrnj3L1j+vPS9p+nJGs2d8TdZTEsk4=";
  };

  nativeBuildInputs = [
    nodejs
    npmHooks.npmInstallHook
    pnpmConfigHook
    pnpm_9
  ];

  buildInputs = lib.optionals withSystemd [
    systemdMinimal
  ];

  buildPhase = ''
    runHook preBuild

    pnpm run build

    runHook postBuild
  '';

  dontNpmPrune = true;

  passthru.tests.zigbee2mqtt = nixosTests.zigbee2mqtt;
  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/Koenkk/zigbee2mqtt/releases/tag/${finalAttrs.version}";
    description = "Zigbee to MQTT bridge using zigbee-shepherd";
    homepage = "https://github.com/Koenkk/zigbee2mqtt";
    license = lib.licenses.gpl3;
    longDescription = ''
      Allows you to use your Zigbee devices without the vendor's bridge or gateway.

      It bridges events and allows you to control your Zigbee devices via MQTT.
      In this way you can integrate your Zigbee devices with whatever smart home infrastructure you are using.
    '';
    maintainers = with lib.maintainers; [
      sweber
      hexa
    ];
    mainProgram = "zigbee2mqtt";
  };
})
