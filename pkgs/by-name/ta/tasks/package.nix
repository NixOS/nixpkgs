{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook3,
  atk,
  cairo,
  gdk-pixbuf,
  glib,
  gtk3,
  libsecret,
  libxkbcommon,
  openssl,
  pango,
  sqlite,
  vulkan-loader,
  wayland,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "tasks";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "edfloreshz";
    repo = "tasks";
    rev = "refs/tags/${version}";
    hash = "sha256-OKXkAJ+TyMnTzvlUPwPU2MWgCTIN3cDiPcVPOzU4WEg=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.16.0" = "sha256-yeBzocXxuvHmuPGMRebbsYSKSvN+8sUsmaSKlQDpW4w=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-tovB4fjPVVRY8LKn5albMzskFQ+1W5ul4jT5RXx9gKE=";
      "cosmic-config-0.1.0" = "sha256-ptFuB56qyYNq15RNtJr62AR6C1wn8revNsHrfRlirg8=";
      "cosmic-settings-daemon-0.1.0" = "sha256-TRXYsnodKjKacc2eVndviEPpma/NNOWstG+ipGcQ0s4=";
      "cosmic-text-0.12.1" = "sha256-u2Tw+XhpIKeFg8Wgru/sjGw6GUZ2m50ZDmRBJ1IM66w=";
      "dpi-0.1.1" = "sha256-whi05/2vc3s5eAJTZ9TzVfGQ/EnfPr0S4PZZmbiYio0=";
      "iced_glyphon-0.6.0" = "sha256-u1vnsOjP8npQ57NNSikotuHxpi4Mp/rV9038vAgCsfQ=";
      "smithay-clipboard-0.8.0" = "sha256-4InFXm0ahrqFrtNLeqIuE3yeOpxKZJZx+Bc0yQDtv34=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
    };
  };

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    atk
    cairo
    gdk-pixbuf
    glib
    gtk3
    libsecret
    libxkbcommon
    openssl
    pango
    sqlite
    vulkan-loader
    wayland
  ];

  postFixup = ''
    wrapProgram $out/bin/tasks \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          libxkbcommon
          wayland
        ]
      }"
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Simple task management application for the COSMIC desktop";
    homepage = "https://github.com/edfloreshz/tasks";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    platforms = lib.platforms.linux;
    mainProgram = "tasks";
  };
}
