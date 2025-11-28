{
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
  rust-jemalloc-sys,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zerofs";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "Barre";
    repo = "ZeroFS";
    tag = "v${finalAttrs.version}";
    hash = "sha256-G+kXAlPfo3YhAGy9nkKCL7384dWUvPr4cZ+WIX99OSc=";
  };

  sourceRoot = "${finalAttrs.src.name}/zerofs";

  cargoHash = "sha256-XbjtlWQkXanOo7SbbgsZNXj5SKy0PQAd2eRM/9f9gLs=";

  buildInputs = [ rust-jemalloc-sys ];

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
