{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  pkg-config,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "xwin";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "Jake-Shadle";
    repo = "xwin";
    tag = finalAttrs.version;
    hash = "sha256-p7rrZ2yxSpGKNuddcSO2wlvsIFj8LYG91tCK1mWO+NY=";
  };

  cargoHash = "sha256-e2uYAE2veYDNZpHr40bpIbplg7orW8oIxgZORhPpbFY=";

  strictDeps = true;
  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  buildNoDefaultFeatures = true;
  buildFeatures = [
    "native-tls"
  ];

  doCheck = true;
  # Requires network access
  checkFlags = [
    "--skip=verify_compiles"
    "--skip=verify_deterministic"
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
