{
  lib,
  stdenv,
  fetchFromGitLab,
  rustPlatform,
  pkg-config,
  #libgit2,
  openssl,
  sqlite,
  libiconv,
}:

rustPlatform.buildRustPackage rec {
  pname = "terminal-typeracer";
  version = "2.1.5";

  src = fetchFromGitLab {
    owner = "ttyperacer";
    repo = "terminal-typeracer";
    rev = "v${version}";
    hash = "sha256-7LKpOO+PVGGtFJh1dZW/n/zovTxxZbb2VQwzgmjZhIY=";
  };

  cargoHash = "sha256-PECQ6KoHLPgUosC7gxniIoLHA5tWb0JfAUm93XFCcpk=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    #libgit2
    openssl
    sqlite
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  OPENSSL_NO_VENDOR = 1;
  LIBGIT2_NO_VENDOR = 0;

  meta = with lib; {
    description = "Open source terminal based version of Typeracer written in rust";
    homepage = "https://gitlab.com/ttyperacer/terminal-typeracer";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ yoctocell ];
    mainProgram = "typeracer";
    platforms = platforms.unix;
  };
}
