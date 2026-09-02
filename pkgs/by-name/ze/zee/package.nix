{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zee";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "zee-editor";
    repo = "zee";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/9SogKOaXdFDB+e0//lrenTTbfmXqNFGr23L+6Pnm8w=";
  };

  cargoHash = "sha256-auwbpavF/WZQIE/htYXJ4di6xoRtXkBBkP/Bj4lFp6U=";

  cargoPatches = [
    # fixed upstream but unreleased
    ./update-ropey-for-rust-1.65.diff
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  # disable downloading and building the tree-sitter grammars at build time
  # grammars can be configured in a config file and installed with `zee --build`
  # see https://github.com/zee-editor/zee#syntax-highlighting
  env.ZEE_DISABLE_GRAMMAR_BUILD = 1;

  meta = {
    description = "Modern text editor for the terminal written in Rust";
    homepage = "https://github.com/zee-editor/zee";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ booklearner ];
    mainProgram = "zee";
  };
})
