{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeBinaryWrapper,
  wofi,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wofi-power-menu";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "szaffarano";
    repo = "wofi-power-menu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iz+iiJv5MEQ/Yh6h28uPgRrmnw7xM/X4nUW+VHCarpE=";
  };

  cargoHash = "sha256-6CNoHxC1AMTbbx3s4eqYPfqJ3pePdN2DJw6INUQFbek=";

  nativeBuildInputs = [ makeBinaryWrapper ];

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
