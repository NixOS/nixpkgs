{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeBinaryWrapper,
  wofi,
  versionCheckHook,
  nix-update-script,
  yq,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wofi-power-menu";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "szaffarano";
    repo = "wofi-power-menu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3m4zTmjYn1WGdW5dY4tzYxOxdw0spwYxZFRhdBwWf2I=";
  };

  postPatch = ''
    tomlq -ti '.package.version = "0.3.1"' Cargo.toml
  '';

  cargoHash = "sha256-5txhSjCXlGqTmeG9EO1AUbt4syrTD62g4LtfO6nhAes=";

  nativeBuildInputs = [
    makeBinaryWrapper
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
