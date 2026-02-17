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
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "Jake-Shadle";
    repo = "xwin";
    tag = finalAttrs.version;
    hash = "sha256-alD8hX1CqtVlkoUhD/C4APWlmUaV7WsZgCYdH39cc5s=";
  };

  cargoHash = "sha256-btcamYbahRRsI/OCCg2YjZ/x6qslKfjjto8QXyYfKI4=";

  strictDeps = true;
  nativeBuildInputs = [
    pkg-config
  ];

  buildNoDefaultFeatures = true;

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
