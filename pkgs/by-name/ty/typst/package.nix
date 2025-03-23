{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  openssl,
  xz,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "typst";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "typst";
    repo = "typst";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vbBwIQt4xWZaKpXgFwDsRQIQ0mmsQPRR39m8iZnnuj0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-4kVj2BODEFjLcrh5sxfcgsdLF2Zd3K1GnhA4DEz1Nl4=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    openssl
    xz
  ];

  env = {
    GEN_ARTIFACTS = "artifacts";
    OPENSSL_NO_VENDOR = true;
  };

  # Fix for "Found argument '--test-threads' which wasn't expected, or isn't valid in this context"
  postPatch = ''
    substituteInPlace tests/src/tests.rs --replace-fail 'ARGS.num_threads' 'ARGS.test_threads'
    substituteInPlace tests/src/args.rs --replace-fail 'num_threads' 'test_threads'
  '';

  postInstall = ''
    installManPage crates/typst-cli/artifacts/*.1
    installShellCompletion \
      crates/typst-cli/artifacts/typst.{bash,fish} \
      --zsh crates/typst-cli/artifacts/_typst
  '';

  cargoTestFlags = [ "--workspace" ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/typst/typst/releases/tag/v${finalAttrs.version}";
    description = "New markup-based typesetting system that is powerful and easy to learn";
    homepage = "https://github.com/typst/typst";
    license = lib.licenses.asl20;
    mainProgram = "typst";
    maintainers = with lib.maintainers; [
      drupol
      figsoda
      kanashimia
    ];
  };
})
