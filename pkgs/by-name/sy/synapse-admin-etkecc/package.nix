{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  nodejs,
  nix-update-script,
  writers,
  baseUrl ? null,
}:

assert lib.asserts.assertMsg (
  baseUrl == null
) "The baseUrl parameter is deprecated, please use .withConfig instead";

stdenv.mkDerivation (finalAttrs: {
  pname = "synapse-admin-etkecc";
  version = "0.10.4-etke40";

  src = fetchFromGitHub {
    owner = "etkecc";
    repo = "synapse-admin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QIOQ25K/QCpSAz3HMOADSIVb3iqfdNCNmWrn7xD0ytU=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-YQZN9tj0zGnC4gmTvHM32mdaOw5RFuUL2ZKd9/8GNZA=";
  };

  nativeBuildInputs = [
    nodejs
    yarnConfigHook
    yarnBuildHook
  ];

  env = {
    NODE_ENV = "production";
    SYNAPSE_ADMIN_VERSION = finalAttrs.version;
  };

  installPhase = ''
    runHook preInstall
    cp -r dist $out
    runHook postInstall
  '';

  passthru = {
    # https://github.com/etkecc/synapse-admin/blob/main/docs/config.md
    withConfig =
      config:
      stdenv.mkDerivation {
        inherit (finalAttrs) version meta;
        pname = "synapse-admin-etkecc-with-config";
        dontUnpack = true;
        configFile = writers.writeJSON "synapse-admin-config" config;
        installPhase = ''
          runHook preInstall
          cp -r ${finalAttrs.finalPackage} $out
          chmod -R +w $out
          cp $configFile $out/config.json
          runHook postInstall
        '';
      };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "Maintained fork of the admin console for (Matrix) Synapse homeservers, including additional features";
    homepage = "https://github.com/etkecc/synapse-admin";
    changelog = "https://github.com/etkecc/synapse-admin/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ defelo ];
  };
})
