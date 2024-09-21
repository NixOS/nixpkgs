{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, pkg-config
, openssl
, xz
, stdenv
, darwin
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "typst";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "typst";
    repo = "typst";
    rev = "v${version}";
    hash = "sha256-FagjVU8BJZStE/geexZERuV2P28iF/pPn2mTi1Gu9iU=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "typst-dev-assets-0.11.1" = "sha256-SMRtitDHFpdMEoOuPBnC3RBTyZ96hb4KmMSCXpAyKfU=";
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

  postPatch = ''
    # Fix for "Found argument '--test-threads' which wasn't expected, or isn't valid in this context"
    substituteInPlace tests/src/tests.rs --replace-fail 'ARGS.num_threads' 'ARGS.test_threads'
    substituteInPlace tests/src/args.rs --replace-fail 'num_threads' 'test_threads'

    # Fix build with Rust 1.80; remove on next release
    ln -sf ${./Cargo.lock} Cargo.lock
  '';

  postInstall = ''
    installManPage crates/typst-cli/artifacts/*.1
    installShellCompletion \
      crates/typst-cli/artifacts/typst.{bash,fish} \
      --zsh crates/typst-cli/artifacts/_typst
  '';

  cargoTestFlags = [ "--workspace" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/typst/typst/releases/tag/${src.rev}";
    description = "New markup-based typesetting system that is powerful and easy to learn";
    homepage = "https://github.com/typst/typst";
    license = lib.licenses.asl20;
    mainProgram = "typst";
    maintainers = with lib.maintainers; [ drupol figsoda kanashimia ];
  };
}
