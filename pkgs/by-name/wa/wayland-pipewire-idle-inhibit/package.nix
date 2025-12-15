{
  lib,
  fetchFromGitHub,
  pipewire,
  pkg-config,
  rustPlatform,
  wayland,
  wayland-protocols,
}:
rustPlatform.buildRustPackage rec {
  pname = "wayland-pipewire-idle-inhibit";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "rafaelrc7";
    repo = "wayland-pipewire-idle-inhibit";
    rev = "v${version}";
    hash = "sha256-VhwYt/XJ6D/ZzW1/p6iSygbGGPyYGEtAx7yXStVjrsA=";
  };

  cargoHash = "sha256-G5jLQ7os7znrYtYhBVgYmVxuB0opQUdu2BEQWYkUX2U=";

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
}
