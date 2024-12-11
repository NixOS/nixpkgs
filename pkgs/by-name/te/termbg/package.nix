{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "termbg";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = "termbg";
    rev = "v${version}";
    hash = "sha256-KLWfdA7TArJqYoxIXQavaTNw/lmWQN9aeltxssIUEvk=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  meta = {
    description = "Program for terminal background color detection";
    homepage = "https://github.com/dalance/termbg";
    changelog = "https://github.com/dalance/termbg/blob/${src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ pinpox ];
    mainProgram = "termbg";
  };
}
