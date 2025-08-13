{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  zlib,
}:

rustPlatform.buildRustPackage rec {
  pname = "tui-journal";
  version = "0.16.1";

  src = fetchFromGitHub {
    owner = "AmmarAbouZor";
    repo = "tui-journal";
    rev = "v${version}";
    hash = "sha256-crrh7lV5ZMKaxsrFmhXsUgBMbN5nmbf8wQ6croTqUKI=";
  };

  cargoHash = "sha256-PmQDLGOXvI0OJ+gMsYa/XLc0WgSH6++23X/b1+iU3JQ=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2
    zlib
  ];

  meta = with lib; {
    description = "Your journal app if you live in a terminal";
    homepage = "https://github.com/AmmarAbouZor/tui-journal";
    changelog = "https://github.com/AmmarAbouZor/tui-journal/blob/${src.rev}/CHANGELOG.ron";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "tjournal";
  };
}
