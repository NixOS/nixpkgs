{
  fetchFromGitHub,
  rustPlatform,
  lib,
}:

rustPlatform.buildRustPackage rec {
  pname = "tarssh";
  version = "0.7.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "Freaky";
    repo = pname;
    sha256 = "sha256-AoKc8VF6rqYIsijIfgvevwu+6+suOO7XQCXXgAPNgLk=";
  };

  cargoHash = "sha256-w1MNsMSGONsAAjyvAHjio2K88j1sqyP1Aqmw3EMya+c=";

  meta = {
    description = "Simple SSH tarpit inspired by endlessh";
    homepage = "https://github.com/Freaky/tarssh";
    license = [ lib.licenses.mit ];
    maintainers = with lib.maintainers; [ sohalt ];
    platforms = lib.platforms.unix;
    mainProgram = "tarssh";
  };
}
