{
  lib,
  fetchFromGitHub,
  pipewire,
  pkg-config,
  rustPlatform,
  wayland,
  wayland-protocols,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wayland-pipewire-idle-inhibit";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "rafaelrc7";
    repo = "wayland-pipewire-idle-inhibit";
    rev = "v${finalAttrs.version}";
    hash = "sha256-AIj8Ib66ej35UNlbvGh0zW2lpGQfsh2aJbnxgBNaWAY=";
  };

  cargoHash = "sha256-MFNtEyBmrkq2ZpKtGA5GEnJilHpZZvG3j2XcF6kNP9k=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    pipewire
    wayland
    wayland-protocols
  ];

  meta = {
    description = "Suspends automatic idling of Wayland compositors when media is being played through Pipewire";
    homepage = "https://github.com/rafaelrc7/wayland-pipewire-idle-inhibit/";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ rafameou ];
    mainProgram = "wayland-pipewire-idle-inhibit";
  };
})
