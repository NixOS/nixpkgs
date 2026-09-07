{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wpawolf";
  version = "1.2.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "StrongWind1";
    repo = "WPAWolf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uIwqUjrQyXKigOlZEpdz79dLMDSLBPywAlEI+EPtY7Q=";
  };

  cargoHash = "sha256-RurWRGy5K1Y/XjdSLLkUEbOZhYdYf7MgEcQJGT07FXk=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "WPA/WPA2/WPA3 PSK handshake extractor for hashcat modes 22000 and 37100";
    homepage = "https://github.com/StrongWind1/WPAWolf";
    changelog = "https://github.com/StrongWind1/WPAWolf/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "wpawolf";
  };
})
