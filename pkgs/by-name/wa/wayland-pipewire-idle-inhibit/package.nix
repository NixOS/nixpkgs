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
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "rafaelrc7";
    repo = "wayland-pipewire-idle-inhibit";
    rev = "v${version}";
    hash = "sha256-8oVTexYGQWyaAVJedrp4kIQ7VjBR47l65eByZr7oghg=";
  };

  cargoHash = "sha256-6MzV2JOVFezD9fVDbzZ6Zm9RWOexh5LPk6AWOleOc2Q=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    pipewire
    wayland
    wayland-protocols
  ];

  meta = with lib; {
    description = "Suspends automatic idling of Wayland compositors when media is being played through Pipewire";
    homepage = "https://github.com/rafaelrc7/wayland-pipewire-idle-inhibit/";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ rafameou ];
    mainProgram = "wayland-pipewire-idle-inhibit";
  };
}
