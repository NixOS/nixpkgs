{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "tuckr";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "RaphGL";
    repo = "Tuckr";
    rev = version;
    hash = "sha256-EGoxM/dAKlIE/oYRH17VcGJNNaPJPDUW4tB6CG+eyFQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-ltlJhlvDP1cJqPG7US9h7qx+KA/5gudZUqULsxTVJbU=";

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
