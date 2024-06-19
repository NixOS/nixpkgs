{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "talecast";
  version = "0.1.39";

  src = fetchFromGitHub {
    owner = "TBS1996";
    repo = pname;
    rev = "816e11dcc5eafbe54d2ecd4bc525a46f88a3e154";
    hash = "sha256-sR0wyzAwTTwO+HHly4I0JJ5HwxJUD1yGdKl9LqEbnI0=";
  };

  cargoHash = "sha256-mIzrYlAqHYrK2bb/ZUzqIwhPJKcTQpNpqijpEuwLc5A=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  meta = {
    description = "Simple CLI podcatcher";
    homepage = "https://github.com/TBS1996/TaleCast";
    license = lib.licenses.mit;
    mainProgram = "talecast";
    maintainers = [ lib.maintainers.confusedalex ];
  };
}
