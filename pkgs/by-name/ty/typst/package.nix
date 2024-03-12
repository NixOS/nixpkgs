{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, pkg-config
, openssl
, xz
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "typst";
  version = "0.11.0-rc1";

  src = fetchFromGitHub {
    owner = "typst";
    repo = "typst";
    rev = "v${version}";
    hash = "sha256-jOq+aoBSRUTXldg8iWGSJ1z0y+3KbhZfVAgjZo9IsGo=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "typst-dev-assets-0.10.0" = "sha256-EBOZbblbavtsr2LEnoIF0UFmpSsm8Sq7ibxxWcAMIHY=";
    };
  };

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    openssl
    xz
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreFoundation
    darwin.apple_sdk.frameworks.CoreServices
    darwin.apple_sdk.frameworks.Security
  ];

  env = {
    GEN_ARTIFACTS = "artifacts";
    OPENSSL_NO_VENDOR = true;
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
