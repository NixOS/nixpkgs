{
  lib,
  rustPlatform,
  stdenv,
  fetchFromGitHub,
  libxkbcommon,
  nix-update-script,
  pkg-config,
  versionCheckHook,
  wayland,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wdotool";
  version = "0.5.3";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "cushycush";
    repo = "wdotool";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kmEMkkU5cy2AqEzbpm4Dp+FzguzldzWqD5KSr7uskLE=";
  };

  cargoHash = "sha256-0sifatYl+aGX+on2mXlMJg7/zKjpORNV3pEv9ZcdZZI=";

  cargoBuildFlags = [ "--package=wdotool" ];
  cargoTestFlags = finalAttrs.cargoBuildFlags;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libxkbcommon
    wayland
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Wayland-native input and window automation tool";
    homepage = "https://github.com/cushycush/wdotool";
    changelog = "https://github.com/cushycush/wdotool/releases/tag/v${finalAttrs.version}";
    license =
      with lib.licenses;
      OR [
        asl20
        mit
      ];
    maintainers = with lib.maintainers; [ johnrichardrinehart ];
    mainProgram = "wdotool";
    platforms = lib.platforms.linux;
  };
})
