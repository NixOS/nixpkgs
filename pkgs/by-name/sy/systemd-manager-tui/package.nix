{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "systemd-manager-tui";
  version = "1.0.8";

  src = fetchFromGitHub {
    owner = "Matheus-git";
    repo = "systemd-manager-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0MeVOu0d94PLVm4VX2rapUACSi8Yvsc5EXHnDuWthd0=";
  };

  cargoHash = "sha256-CS5U1PA+DzgT4hnv5bqKphS1fiJt1tr7MaMC2hZmeGQ=";

  meta = {
    homepage = "https://github.com/Matheus-git/systemd-manager-tui";
    description = "Program for managing systemd services through a TUI";
    mainProgram = "systemd-manager-tui";
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vuimuich ];
  };
})
