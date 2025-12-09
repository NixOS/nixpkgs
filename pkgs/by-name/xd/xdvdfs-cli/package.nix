{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "xdvdfs-cli";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "antangelo";
    repo = "xdvdfs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-58f9eznPKeUVnUvslcm0CQPC+1xU3Zto+R56IXPBKT4=";
  };

  cargoHash = "sha256-vNCqfXsPjb3mph28YuYKpWTs9VHbIcXs6GVn4XgQKtQ=";

  cargoBuildFlags = [ "--package xdvdfs-cli" ];
  cargoTestFlags = [ "--package xdvdfs-cli" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/xdvdfs";
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "xdvdfs";
    description = "Original Xbox DVD Filesystem library and management tool";
    homepage = "https://github.com/antangelo/xdvdfs";
    changelog = "https://github.com/antangelo/xdvdfs/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
