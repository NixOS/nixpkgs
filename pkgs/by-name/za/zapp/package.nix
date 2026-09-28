{
  lib,
  udev,
  stdenv,
  pkg-config,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zapp";
  version = "1.0.2";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "zsa";
    repo = "zapp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-K+L8Hyw8BFyYoHGofRJrZqwTwth3Q2ypAq3uj8rO57I=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    udev
  ];

  cargoHash = "sha256-4MhPi6Ej37M+O7OE5sgzS7zhUhgawLEwxkNRSadwVcI=";
  passthru.updateScript = nix-update-script { };
  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Flash ZSA keyboards from your terminal";
    homepage = "https://github.com/zsa/zapp";
    license = with lib.licenses; [
      mit
      commons-clause
    ];
    maintainers = with lib.maintainers; [ Mr-Stoneman ];
    mainProgram = "zapp";
  };
})
