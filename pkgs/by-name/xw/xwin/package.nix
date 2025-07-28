{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "xwin";
  version = "0.6.6";

  src = fetchFromGitHub {
    owner = "Jake-Shadle";
    repo = "xwin";
    tag = finalAttrs.version;
    hash = "sha256-bow/TJ6aIXoNZDqCTlQYAMxEUiolby1axsKiLMk/jiA=";
  };

  cargoHash = "sha256-S/3EjlG0Dr/KKAYSFaX/aFh/CIc19Bv+rKYzKPWC+MI=";

  doCheck = true;
  # Requires network access
  checkFlags = [
    "--skip verify_compiles"
    "--skip verify_deterministic"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = placeholder "out" + "/bin/xwin";

  meta = {
    description = "Utility for downloading the Microsoft CRT & Windows SDK libraries";
    homepage = "https://github.com/Jake-Shadle/xwin";
    changelog = "https://github.com/Jake-Shadle/xwin/releases/tag/" + finalAttrs.version;
    mainProgram = "xwin";
    license = [
      lib.licenses.mit
      lib.licenses.asl20
    ];
    maintainers = with lib.maintainers; [ RossSmyth ];
    platforms = with lib.platforms; linux ++ darwin ++ windows;
  };
})
