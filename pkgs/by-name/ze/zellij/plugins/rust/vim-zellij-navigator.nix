{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vim-zellij-navigator";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "hiasr";
    repo = "vim-zellij-navigator";
    tag = finalAttrs.version;
    hash = "sha256-1zzY1Z8ZpiNTdFW+gKRYaRR+oCzMnbJA2szY0k24bGg=";
  };

  cargoHash = "sha256-AbfgDhQEbm5qULw2HHxG5EMCYdML4VhHxJaAqP2g3u0=";

  meta = {
    description = "Seamless navigation between Zellij panes and Vim splits";
    homepage = "https://github.com/hiasr/vim-zellij-navigator";
    changelog = "https://github.com/hiasr/vim-zellij-navigator/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ PerchunPak ];
  };
})
