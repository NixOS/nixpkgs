{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wepwolf";
  version = "1.2.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "StrongWind1";
    repo = "WEPWolf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZjhI9pmanBMkOIVHHLhC40sBqLyu24RAuBqLGjJDksM=";
  };

  cargoHash = "sha256-Rv8A5X644BgM0v/RwreHPTxZpQo+rvsny6vvO23cDRY=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = false;

  pythonImportsCheck = [ "wepwolf_docs" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for offline, passive WEP key recovery from 802.11 captures";
    homepage = "https://github.com/StrongWind1/WEPWolf";
    changelog = "https://github.com/StrongWind1/WEPWolf/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "wepwolf";
  };
})
