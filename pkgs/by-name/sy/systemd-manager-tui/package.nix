{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "systemd-manager-tui";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "Matheus-git";
    repo = "systemd-manager-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SFzqjd9qxXxuadSxNaCM0eGEWIiGJdXqoyXYqWqKOAc=";
  };

  cargoHash = "sha256-wMuEh2m07gsOj52Bhd5BnvVRu1uZqOiQurqmcpDylXM=";

  meta = {
    homepage = "https://github.com/Matheus-git/systemd-manager-tui";
    description = "Program for managing systemd services through a TUI";
    mainProgram = "systemd-manager-tui";
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vuimuich ];
  };
})
