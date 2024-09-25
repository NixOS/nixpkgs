{ lib
, rustPlatform
, fetchFromGitHub
, gst_all_1
, mesa
, pkg-config
, libglvnd
, libxkbcommon
, pipewire
, wayland
}:

rustPlatform.buildRustPackage rec {
  pname = "xdg-desktop-portal-cosmic";
  version = "1.0.0-alpha.2";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = pname;
    rev = "epoch-${version}";
    hash = "sha256-MbcktIXkiH3uxQLduXF76ZGn2aoTd/D6xKeUM4M/btM=";
  };

  env.VERGEN_GIT_COMMIT_DATE = "2024-09-24";
  env.VERGEN_GIT_SHA = src.rev;

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-1UwgRyUe0PQrZrpS7574oNLi13fg5HpgILtZGW6JNtQ=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-cG5vnkiyDlQnbEfV2sPbmBYKv1hd3pjJrymfZb8ziKk=";
      "cosmic-bg-config-0.1.0" = "sha256-lAFAZBo5FnXgJV3MrZhaYmBxqtH1E7+Huj53ho/hPik=";
      "cosmic-client-toolkit-0.1.0" = "sha256-1XtyEvednEMN4MApxTQid4eed19dEN5ZBDt/XRjuda0=";
      "cosmic-config-0.1.0" = "sha256-gXrMEoAN+7nYAEcs4w6wROhQTjMCxkGn+muJutktLyk=";
      "cosmic-files-0.1.0" = "sha256-rBR6IPpMgOltyaRPPZ5V8tYH/xtQphgrPWci/kvlgEg=";
      "cosmic-settings-daemon-0.1.0" = "sha256-6cEgFfkBxEpIo8LsvKDR2khMdhEz/dp2oYJXXBiC9zg=";
      "cosmic-text-0.12.1" = "sha256-u2Tw+XhpIKeFg8Wgru/sjGw6GUZ2m50ZDmRBJ1IM66w=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "fs_extra-1.3.0" = "sha256-ftg5oanoqhipPnbUsqnA4aZcyHqn9XsINJdrStIPLoE=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "libspa-0.8.0" = "sha256-kp5x5QhmgEqCrt7xDRfMFGoTK5IXOuvW2yOW02B8Ftk=";
      "smithay-clipboard-0.8.0" = "sha256-4InFXm0ahrqFrtNLeqIuE3yeOpxKZJZx+Bc0yQDtv34=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
      "trash-5.1.1" = "sha256-So8rQ8gLF5o79Az396/CQY/veNo4ticxYpYZPfMJyjQ=";
      "winit-0.29.10" = "sha256-ScTII2AzK3SC8MVeASZ9jhVWsEaGrSQ2BnApTxgfxK4=";
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
  '';

  meta = with lib; {
    homepage = "https://github.com/pop-os/xdg-desktop-portal-cosmic";
    description = "XDG Desktop Portal for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nyabinary ];
    mainProgram = "xdg-desktop-portal-cosmic";
    platforms = platforms.linux;
  };
}
