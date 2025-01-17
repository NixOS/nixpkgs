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
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "szaffarano";
    repo = "wofi-power-menu";
    tag = "v${version}";
    hash = "sha256-V1aN8jkWmZz+ynVzZlDE/WYSBnt8XpPEb6NImd6OA4g=";
  };

  cargoHash = "sha256-KWpPyuI963v4D5uLUBNoLWU29lM1PD46uSR1LAUI+Es=";

  postPatch = ''
    sed -i 's/^version = .*/version = "${version}"/' Cargo.toml
  '';

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
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ defelo ];
    mainProgram = "wofi-power-menu";
  };
}
