{
  stdenv,
  lib,
  cmake,
  fetchFromGitHub,
  nix-update-script,
  rust-jemalloc-sys,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zerofs";
  version = "0.22.1";

  src = fetchFromGitHub {
    owner = "Barre";
    repo = "ZeroFS";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YdqZV8TdodSKP3h2Qa0+Xi7bfGKrtGq625Oco+UjIpU=";
  };

  sourceRoot = "${finalAttrs.src.name}/zerofs";

  cargoHash = "sha256-rPa8XmApLClhJ2oAQxEoQL2Hd+8QlJAOZVw+kzS70KY=";

  nativeBuildInputs = [ cmake ];

  buildInputs = [ rust-jemalloc-sys ];

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
