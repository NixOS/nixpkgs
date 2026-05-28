{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zellij-autolock";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "fresh2dev";
    repo = "zellij-autolock";
    tag = finalAttrs.version;
    hash = "sha256-uU7wWSdOhRLQN6cG4NvA9yASlvRwB6gggX89B5K9dyQ=";
  };

  cargoHash = "sha256-ULBQN+EBvyEIdoaLpiMNqoDEQ8Lu0Sc3OeweuKMiIU0=";

  meta = {
    description = "Autolock Zellij when certain processes open";
    homepage = "https://github.com/fresh2dev/zellij-autolock";
    changelog = "https://github.com/fresh2dev/zellij-autolock/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
  };
})
