{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zellij-sessionizer";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "laperlej";
    repo = "zellij-sessionizer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uCUoafvtDY62eqUH9d9HEAAqQ0/q6glivcYQyYx5T5w=";
  };

  cargoHash = "sha256-txSzHKGeAScRFwx1RzlNT0oscEw+5hLcCpb3N5ke4yo=";

  meta = {
    description = "Fuzzy-find your projects (port of tmux-sessionizer)";
    homepage = "https://github.com/laperlej/zellij-sessionizer";
    changelog = "https://github.com/laperlej/zellij-sessionizer/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
  };
})
