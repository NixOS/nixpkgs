{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wepwolf";
  version = "1.3.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "StrongWind1";
    repo = "WEPWolf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/5gqJz491cUBiSgN86qi0GT2/zxW5c4Z//YNrh7V6A8=";
  };

  cargoHash = "sha256-FTcCKGTUBS5bWadWjUw/uk2xuZmPyOeg6lNYcv7mwIk=";

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
