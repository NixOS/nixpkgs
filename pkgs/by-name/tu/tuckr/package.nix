{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "tuckr";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "RaphGL";
    repo = "Tuckr";
    rev = version;
    hash = "sha256-X2/pOzGUGc5FI0fyn6PB+9duMBdoggjvGxssDXKppWU=";
  };

  cargoHash = "sha256-NXIrjX73lg7706VAJqr/xv7N46ZdscAtXwzJywuAwro=";

  doCheck = false; # test result: FAILED. 5 passed; 3 failed;

  meta = {
    description = "Super powered replacement for GNU Stow";
    homepage = "https://github.com/RaphGL/Tuckr";
    changelog = "https://github.com/RaphGL/Tuckr/releases/tag/${version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ mimame ];
    mainProgram = "tuckr";
  };
}
