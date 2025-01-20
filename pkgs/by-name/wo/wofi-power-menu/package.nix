{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  wofi,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "wofi-power-menu";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "szaffarano";
    repo = "wofi-power-menu";
    tag = "v${version}";
    hash = "sha256-UDDDtI6wnx64KG+1/S6bYTc1xi1vOFuZOmRCLK2Yzew=";
  };

  cargoHash = "sha256-NNlUV9hMIOXxYnCx5/njqQSEE5xIkbPRhTMet4oNJt0=";

  nativeBuildInputs = [ makeWrapper ];

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
    changelog = "https://github.com/szaffarano/wofi-power-menu/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ defelo ];
    mainProgram = "wofi-power-menu";
  };
}
