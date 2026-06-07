{
  lib,
  rustPlatform,
  fetchFromGitHub,
  ncurses,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wiki-tui";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "Builditluc";
    repo = "wiki-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hUAe2mzz/4xdpyPE2rbTq5WKk0bNa4dSFocFiCXyO4Q=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    ncurses
    openssl
  ];

  cargoHash = "sha256-0M3vHj/dzHcI2FJLramTsFMw4m/WGp9vX9Tq52dSW1o=";

  meta = {
    description = "Simple and easy to use Wikipedia Text User Interface";
    homepage = "https://github.com/builditluc/wiki-tui";
    changelog = "https://github.com/Builditluc/wiki-tui/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      builditluc
      matthiasbeyer
    ];
    mainProgram = "wiki-tui";
  };
})
