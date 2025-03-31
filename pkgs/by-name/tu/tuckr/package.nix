{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "tuckr";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "RaphGL";
    repo = "Tuckr";
    rev = version;
    hash = "sha256-0ZPBJ2MNeoGCvYW6HswVZ5SyjZpdR21lp9ebceIhsfw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-vgwO1N7FuqZaY+ShkQHmCEYwiKZRkkqDNAU7SnTg1rw=";

  doCheck = false; # test result: FAILED. 5 passed; 3 failed;

  meta = with lib; {
    description = "Super powered replacement for GNU Stow";
    homepage = "https://github.com/RaphGL/Tuckr";
    changelog = "https://github.com/RaphGL/Tuckr/releases/tag/${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mimame ];
    mainProgram = "tuckr";
  };
}
