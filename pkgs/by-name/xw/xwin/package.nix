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
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "Jake-Shadle";
    repo = "xwin";
    tag = finalAttrs.version;
    hash = "sha256-tccavt0VhA5l3rDXxbQu1ueQsoHV55g8/twKp11hrk8=";
  };

  cargoHash = "sha256-jJBLrcMVGbP1NPDgdUPQYM8333XGo6ulbs4qBk2Np90=";

  strictDeps = true;
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
    maintainers = [ lib.maintainers.eveeifyeve ];
    platforms = with lib.platforms; linux ++ darwin ++ windows;
  };
})
