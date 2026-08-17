{
  lib,
  udev,
  stdenv,
  pkg-config,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zapp";
  version = "1.0.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "zsa";
    repo = "zapp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KhWL+SsN1z9qpxwHpaqRo3qAk7xAOHVkRAOa02Q2Myc=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    udev
  ];

  cargoHash = "sha256-gDyNwHrMdNQdKdr9RGfwFAU8IaUlGrlJxV0WClQ25JM=";
  passthru.updateScript = nix-update-script { };
  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Flash ZSA keyboards from your terminal";
    homepage = "https://github.com/zsa/zapp";
    license = with lib.licenses; [
      mit
      commons-clause
    ];
    maintainers = with lib.maintainers; [ Mr-Stoneman ];
    mainProgram = "zapp";
  };
})
