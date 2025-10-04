{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  npmHooks,
  pnpm_9,
  systemdMinimal,
  nixosTests,
  nix-update-script,
  withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemdMinimal,
}:

let
  pnpm = pnpm_9;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "zigbee2mqtt";
  version = "2.6.2";

  src = fetchFromGitHub {
    owner = "Koenkk";
    repo = "zigbee2mqtt";
    tag = finalAttrs.version;
    hash = "sha256-tPjIfFAXtezdHDXBSAYLRPYd0G4p1XnU9R36YBRkYTQ=";
  };

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 1;
    hash = "sha256-E4FAtOa8FQnPbv0wiMdp1k/L/RYoVOLMPZynag5iGjM=";
  };

  nativeBuildInputs = [
    nodejs
    npmHooks.npmInstallHook
    pnpm.configHook
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

  meta = with lib; {
    changelog = "https://github.com/Koenkk/zigbee2mqtt/releases/tag/${finalAttrs.version}";
    description = "Zigbee to MQTT bridge using zigbee-shepherd";
    homepage = "https://github.com/Koenkk/zigbee2mqtt";
    license = licenses.gpl3;
    longDescription = ''
      Allows you to use your Zigbee devices without the vendor's bridge or gateway.

      It bridges events and allows you to control your Zigbee devices via MQTT.
      In this way you can integrate your Zigbee devices with whatever smart home infrastructure you are using.
    '';
    maintainers = with maintainers; [
      sweber
      hexa
    ];
    mainProgram = "zigbee2mqtt";
  };
})
