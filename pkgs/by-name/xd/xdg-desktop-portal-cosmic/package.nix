{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, mesa
, libglvnd
, libxkbcommon
, pipewire
, wayland
, gst_all_1
}:

rustPlatform.buildRustPackage {
  pname = "xdg-desktop-portal-cosmic";
  version = "0-unstable-2024-02-23";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "xdg-desktop-portal-cosmic";
    rev = "f6d394e5d05b6acdf7d39d5211d4dca02b419e39";
    hash = "sha256-3C8YcC/usYwp5uSaD+rKyj8l+qk3vwOZ5XH/HJVkJ7k=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-ksaYMGT/oug7isQY8/1WD97XDUsX2ShBdabUzxWffYw=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "cosmic-bg-config-0.1.0" = "sha256-2P2NcgDmytvBCMbG8isfZrX+JirMwAz8qjW3BhfhebI=";
      "cosmic-client-toolkit-0.1.0" = "sha256-vj7Wm1uJ5ULvGNEwKznNhujCZQiuntsWMyKQbIVaO/Q=";
      "cosmic-config-0.1.0" = "sha256-ETNVJ4y7EraAlU9XEZGNNPdyWt1WIURr1dSH6hQ0Pos=";
      "cosmic-settings-daemon-0.1.0" = "sha256-z/dvRyc3Zc1fAQh2HKk6NI6QSDpNqarqslwszjU+0nc=";
      "cosmic-text-0.11.1" = "sha256-lyBl0VAzcKBqLeCPrA28VW6O0MWXazJg1b11YuBR65U=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "libspa-0.8.0" = "sha256-KnNeFQPu0E4XxZVladf1fbChh0Xjhw3tN9Dqp7uy+/I=";
      "smithay-client-toolkit-0.18.0" = "sha256-2WbDKlSGiyVmi7blNBr2Aih9FfF2dq/bny57hoA4BrE=";
      "softbuffer-0.4.1" = "sha256-CACVCnyFgefkpDlll6IeaPWB8a3gbF6BW8MnlkytV8o=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
    };
  };

  separateDebugInfo = true;

  nativeBuildInputs = [ rustPlatform.bindgenHook pkg-config ];
  buildInputs = [ libglvnd libxkbcommon mesa pipewire wayland ];
  checkInputs = [ gst_all_1.gstreamer ];

  # Force linking to libEGL, which is always dlopen()ed, and to
  # libwayland-client, which is always dlopen()ed except by the
  # obscure winit backend.
  RUSTFLAGS = map (a: "-C link-arg=${a}") [
    "-Wl,--push-state,--no-as-needed"
    "-lEGL"
    "-lwayland-client"
    "-Wl,--pop-state"
  ];

  postInstall = ''
    mkdir -p $out/share/{dbus-1/services,xdg-desktop-portal/portals}
    cp data/*.service $out/share/dbus-1/services/
    cp data/cosmic.portal $out/share/xdg-desktop-portal/portals/
    cp data/cosmic-portals.conf $out/share/xdg-desktop-portal/
  '';

  meta = with lib; {
    homepage = "https://github.com/pop-os/xdg-desktop-portal-cosmic";
    description = "XDG Desktop Portal for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nyanbinary ];
    mainProgram = "xdg-desktop-portal-cosmic";
    platforms = platforms.linux;
  };
}
