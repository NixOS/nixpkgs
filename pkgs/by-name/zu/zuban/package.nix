{
  fetchFromGitHub,
  lib,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zuban";

  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "zubanls";
    repo = "zuban";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mD9ozRWqUKVMiZBkUZnjzcjLbKNi1/jdAeqRinSlBTU=";
  };

  buildAndTestSubdir = "crates/zuban";

  cargoHash = "sha256-gdHFI/HFQKoWixPeVX4xG5V1NaKPUJ9d6BX/dZWYOYg=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Mypy-compatible Python Language Server built in Rust";
    homepage = "https://zubanls.com";
    # There's no changelog file yet, but they post updates on their blog.
    changelog = "https://zubanls.com/blog/";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      mcjocobe
    ];
    platforms = lib.platforms.all;
    mainProgram = "zuban";
  };
})
