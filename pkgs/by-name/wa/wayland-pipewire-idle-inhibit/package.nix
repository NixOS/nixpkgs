{ lib
, fetchFromGitHub
, pipewire
, pkg-config
, rustPlatform
, wayland
, wayland-protocols
}:
rustPlatform.buildRustPackage rec {
  pname = "wayland-pipewire-idle-inhibit";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "rafaelrc7";
    repo = "wayland-pipewire-idle-inhibit";
    rev = "v${version}";
    sha256 = "sha256-pHTIzcmvB66Jwbkl8LtoYVP8+mRiUwT3D29onLdx+gM=";
  };

  cargoHash = "sha256-7RNYA0OqKV2p3pOTsehEQSvVHH/hoJA733S0u7x06Fc=";

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
    description = "Suspends automatic idling of Wayland compositors when media is being played through Pipewire.";
    homepage = "https://github.com/rafaelrc7/wayland-pipewire-idle-inhibit/";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ rafameou ];
    mainProgram = "wayland-pipewire-idle-inhibit";
  };
}

