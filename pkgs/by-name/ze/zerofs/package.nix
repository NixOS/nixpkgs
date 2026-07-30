{
  stdenv,
  lib,
  cmake,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zerofs";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "Barre";
    repo = "ZeroFS";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9GSGMAI4Jhgd7hCTp2XkXPqrU0amYTN47p8LG1b2SDg=";
  };

  sourceRoot = "${finalAttrs.src.name}/zerofs";

  cargoHash = "sha256-f/4kL1RxZ+IGFEzVbni1F4BEyydU5hpLphFssYWFvX0=";

  nativeBuildInputs = [ cmake ];

  env = {
    RUSTFLAGS = "--cfg tokio_unstable";
  };

  checkFlags = [
    # fails with NotPermitted inside the build sandbox
    "--skip=zerofs_client_tests::metadata_operations"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Filesystem That Makes S3 your Primary Storage.";
    longDescription = ''
      ZeroFS makes S3 storage feel like a real filesystem. It provides file-level access
      via NFS and 9P and block-level access via NBD.
    '';
    homepage = "https://www.zerofs.net";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      lblasc
    ];
    changelog = "https://github.com/Barre/ZeroFS/releases/tag/v${finalAttrs.version}";
    mainProgram = "zerofs";
  };
})
