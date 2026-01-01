{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  sqlite,
  zstd,
  nixosTests,
}:

rustPlatform.buildRustPackage rec {
  pname = "wastebin";
<<<<<<< HEAD
  version = "3.4.0";
=======
  version = "3.3.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "matze";
    repo = "wastebin";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-cujMs7R6CBSsoQ3p8PyHAJYwWjd8NGYX+qMB4ntrorg=";
  };

  cargoHash = "sha256-wS4WkOjaDTlrIEjeSTmEqzfC1XZgXQUTqpfs7FYr60Y=";
=======
    hash = "sha256-L19Yz+vGNTdwJ3cYoGnx4m8/J6SMSg1Gbaqph8tQtfE=";
  };

  cargoHash = "sha256-BZlYb7ZRfCKUgO3R+l/ZpLctXHA2N6L3nYTVov2GolI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    sqlite
    zstd
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  passthru.tests = {
    inherit (nixosTests) wastebin;
  };

<<<<<<< HEAD
  meta = {
    description = "Pastebin service";
    homepage = "https://github.com/matze/wastebin";
    changelog = "https://github.com/matze/wastebin/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Pastebin service";
    homepage = "https://github.com/matze/wastebin";
    changelog = "https://github.com/matze/wastebin/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      pinpox
      matthiasbeyer
    ];
    mainProgram = "wastebin";
  };
}
