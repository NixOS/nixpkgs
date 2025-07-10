{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "systemd-manager-tui";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "Matheus-git";
    repo = "systemd-manager-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Vky38cetk5eOSq+J0QjQJBlspa8Yf/0V2cnzPrGmqE4=";
  };

  cargoHash = "sha256-GghQGGgSyZnH6OmFY/D0dR6gBwxgqDutW9wbRheUREA=";

  meta = {
    homepage = "https://github.com/Matheus-git/systemd-manager-tui";
    description = "Program for managing systemd services through a TUI";
    mainProgram = "systemd-manager-tui";
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vuimuich ];
  };
})
