{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  pkg-config,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "xwin";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "Jake-Shadle";
    repo = "xwin";
    tag = finalAttrs.version;
    hash = "sha256-kUbRHrM88x3ezy0+GIpbGQfEROn16dSwPtobjdYauRM=";
  };

  cargoHash = "sha256-34v/YDT0Juwjv8EbwsOsmbp/Q89Z4c+BYxcA60X7Q3A=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  doCheck = true;
  # Requires network access
  checkFlags = [
    "--skip=verify_compiles"
    "--skip=verify_deterministic"
    "--skip=verify_aarch64_compiles"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = placeholder "out" + "/bin/xwin";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Utility for downloading the Microsoft CRT & Windows SDK libraries";
    homepage = "https://github.com/Jake-Shadle/xwin";
    changelog = "https://github.com/Jake-Shadle/xwin/releases/tag/" + finalAttrs.version;
    mainProgram = "xwin";
    license = [
      lib.licenses.mit
      lib.licenses.asl20
    ];
    maintainers = with lib.maintainers; [
      eveeifyeve
      greaka
    ];
    platforms = with lib.platforms; linux ++ darwin ++ windows;
  };
})
