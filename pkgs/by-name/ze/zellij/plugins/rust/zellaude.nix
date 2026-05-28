{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkgsBuildBuild,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zellaude";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "ishefi";
    repo = "zellaude";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jPFiMabR4LHDg6w/1M4PA/w/3VBnrVA6QjwZrMnTwbo=";
  };

  cargoHash = "sha256-4tplwN0qGUhPZay/U03jgxbWl7sdgNL+H6HxCar7jo0=";

  passthru.runtimeDeps = [ pkgsBuildBuild.jq ];

  meta = {
    description = "Claude Code-aware status bar plugin for Zellij";
    homepage = "https://github.com/ishefi/zellaude";
    license = lib.licenses.mit;
  };
})
