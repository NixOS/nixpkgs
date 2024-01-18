{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "typst";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "typst";
    repo = "typst";
    rev = "v${version}";
    hash = "sha256-qiskc0G/ZdLRZjTicoKIOztRFem59TM4ki23Rl55y9s=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "iai-0.1.1" = "sha256-EdNzCPht5chg7uF9O8CtPWR/bzSYyfYIXNdLltqdlR0=";
    };
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
  ];

  env = {
    GEN_ARTIFACTS = "artifacts";
  };

  postInstall = ''
    installManPage crates/typst-cli/artifacts/*.1
    installShellCompletion \
      crates/typst-cli/artifacts/typst.{bash,fish} \
      --zsh crates/typst-cli/artifacts/_typst
  '';

  meta = {
    changelog = "https://github.com/typst/typst/releases/tag/${src.rev}";
    description = "A new markup-based typesetting system that is powerful and easy to learn";
    homepage = "https://github.com/typst/typst";
    license = lib.licenses.asl20;
    mainProgram = "typst";
    maintainers = with lib.maintainers; [ drupol figsoda kanashimia ];
  };
}
