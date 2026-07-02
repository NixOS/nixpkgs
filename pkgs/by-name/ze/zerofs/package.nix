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
  version = "1.2.7";

  src = fetchFromGitHub {
    owner = "Barre";
    repo = "ZeroFS";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8HdqWzqQbqyBNu9W0XqLmrbOHfCsOF7GDmoK9RHUo00=";
  };

  sourceRoot = "${finalAttrs.src.name}/zerofs";

  cargoHash = "sha256-vtu41497VxBUyWpqUAAFO1oWp2yjbB6alk9mMfT4sPk=";

  nativeBuildInputs = [ cmake ];

  checkFlags = [ "--skip=zerofs_client_tests::metadata_operations" ];

  env = {
    RUSTFLAGS = "--cfg tokio_unstable";
  };

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
