{
  fetchFromGitHub,
  lib,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zuban";

  version = "0.0.23";

  src = fetchFromGitHub {
    owner = "zubanls";
    repo = "zuban";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EPF1HW/oqUKHLTorkO3C+X+ziq6i1lCxGY5y1ioKg6A=";
  };

  buildAndTestSubdir = "crates/zuban";

  cargoHash = "sha256-TAFdS4NmXchmhqVRcsckz6GhZG35IE2fukDlZiRF8Ms=";

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
