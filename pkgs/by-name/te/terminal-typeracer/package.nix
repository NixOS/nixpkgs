{
  lib,
  stdenv,
  fetchFromGitLab,
  rustPlatform,
  pkg-config,
  libgit2,
  openssl,
  sqlite,
  libiconv,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "terminal-typeracer";
  version = "2.2.0";

  src = fetchFromGitLab {
    owner = "ttyperacer";
    repo = "terminal-typeracer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xBuHYxpMh/gfdbzCK6lWr6n2rY6WcF3v1/Kx6AtzvKk=";
  };

  cargoHash = "sha256-/g7xRWN+yiN9k3+nfxvQ3Ku4Yr7orHwa5jcXY3S+HSg=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libgit2
    openssl
    sqlite
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open source terminal based version of Typeracer written in rust";
    homepage = "https://gitlab.com/ttyperacer/terminal-typeracer";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ yoctocell ];
    mainProgram = "typeracer";
    platforms = lib.platforms.unix;
  };
})
