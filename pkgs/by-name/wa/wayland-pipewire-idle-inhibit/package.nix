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
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "rafaelrc7";
    repo = "wayland-pipewire-idle-inhibit";
    rev = "v${version}";
    sha256 = "sha256-VOP1VOeXOyjn+AJfSHzVNT0l+rgm63ev9p4uTfMfYY0=";
  };

  cargoSha256 = "sha256-7XuDZ57+F8Ot5oNO9/BXjFljNmoMgNgURfmPEIy2PHo=";

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

