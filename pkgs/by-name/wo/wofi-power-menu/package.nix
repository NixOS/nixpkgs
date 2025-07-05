{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  wofi,
  versionCheckHook,
  nix-update-script,
  yq,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wofi-power-menu";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "szaffarano";
    repo = "wofi-power-menu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WPTK9izFU8xZ5YVFuEGO5EoOzgpXWXQnGgeNYjnb/zA=";
  };

  postPatch = ''
    tomlq -ti '.package.version = "0.2.7"' Cargo.toml
  '';

  useFetchCargoVendor = true;
  cargoHash = "sha256-oJd2ymNkNSGUD3cQ+bEHooAJQNeSarkIHWvGNXezwrM=";

  nativeBuildInputs = [
    makeWrapper
    yq # for `tomlq`
  ];

  postInstall = ''
    wrapProgram $out/bin/wofi-power-menu \
      --prefix PATH : ${lib.makeBinPath [ wofi ]}
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Highly configurable power menu using the wofi launcher power-menu";
    homepage = "https://github.com/szaffarano/wofi-power-menu";
    changelog = "https://github.com/szaffarano/wofi-power-menu/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ defelo ];
    mainProgram = "wofi-power-menu";
  };
})
