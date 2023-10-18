{ lib, rustPlatform, fetchFromGitHub, openssl, libgit2, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "syncat";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "foxfriends";
    repo = "syncat";
    rev = version;
    hash = "sha256-SC3sAJLi//ZSITReiBjmloxhJ71BKtmseFnw7byoZm4=";
  };

  cargoHash = "sha256-rQ3nQn8gZKxp8OcDoqJSZi5KG7JNWaDXNIgcV/rDtlY=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl libgit2 ];

  # Disabled because there currently is no tests
  doCheck = false;

  meta = with lib; {
    description = "Syntax aware cat utility";
    homepage = "https://github.com/foxfriends/syncat";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ mikaelfangel ];
    mainProgram = "syncat";
  };
}
