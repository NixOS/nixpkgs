{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "typstfmt";
  version = "0.2.9";

  src = fetchFromGitHub {
    owner = "astrale-sharp";
    repo = "typstfmt";
    rev = version;
    hash = "sha256-bSjUr6tHQrmni/YmApHrvY2cVz3xf1VKfg35BJjuOZM=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "typst-syntax-0.10.0" = "sha256-qiskc0G/ZdLRZjTicoKIOztRFem59TM4ki23Rl55y9s=";
    };
  };

  meta = {
    changelog = "https://github.com/astrale-sharp/typstfmt/blob/${src.rev}/CHANGELOG.md";
    description = "Formatter for the Typst language";
    homepage = "https://github.com/astrale-sharp/typstfmt";
    license = lib.licenses.mit;
    mainProgram = "typstfmt";
    maintainers = with lib.maintainers; [
      figsoda
      geri1701
    ];
  };
}
