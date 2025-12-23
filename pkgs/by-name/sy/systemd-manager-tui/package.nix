{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "systemd-manager-tui";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "Matheus-git";
    repo = "systemd-manager-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/KtvQBye5Z7xfCO57YhM/s+XOAT4ZIBU6Ycu398haXw=";
  };

  cargoHash = "sha256-g6ES+A73E6k/TPw73azeYXj5R91Y98Im1enYKDqKTVk=";

  meta = {
    homepage = "https://github.com/Matheus-git/systemd-manager-tui";
    description = "Program for managing systemd services through a TUI";
    mainProgram = "systemd-manager-tui";
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vuimuich ];
  };
})
