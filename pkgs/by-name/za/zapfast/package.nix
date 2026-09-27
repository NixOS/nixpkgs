{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  cmake,
  perl,
  alsa-lib,
  alsa-plugins,
  libGL,
  libxkbcommon,
  wayland,
  libx11,
  libxcb,
  libxcursor,
  libxi,
  libxrandr,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zapfast";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "crmne";
    repo = "zapfast";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8ZdS8Y4YTjcOmAdDTSn2RSyf0NReYbsPIraNPV5doO4=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "dpi-0.1.1" = "sha256-x93WYXGAA6SifvOrayIQtyc7N8jT+atScx/R1YRT06k=";
      "egui-0.36.1" = "sha256-uzNVqMeYdLI9jqvPxdsmOkJC17GiPWU0BpJ+aqDz5RM=";
      "fastframe-fonts-0.1.7" = "sha256-ZPpSX2j42BbBOu9W3VZ0H7mJKYgBLRoZ6MRWyEUj1bI=";
      "rodio-0.22.2" = "sha256-snwSU8P9iZeMSKJcX80FWl0IL32dCQqWGjNispeKlps=";
      "whatsapp-rust-0.7.0" = "sha256-+hV1XKntNGClwBUH5t06LSP3YpKJXnP2pmhNXKm2lU0=";
    };
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    perl
  ];

  buildInputs = [
    alsa-lib
    alsa-plugins
    libGL
    libxkbcommon
    wayland
    libx11
    libxcb
    libxcursor
    libxi
    libxrandr
  ];

  # ring ships its own C objects; distro LTO breaks the link (see upstream AUR).
  env.CARGO_PROFILE_RELEASE_LTO = "false";

  # Upstream targets rustc 1.98; nixpkgs may still ship 1.97 until the next rust bump.
  cargoBuildFlags = [ "--ignore-rust-version" ];

  # Layout unit tests are sensitive to font metrics in the build sandbox.
  doCheck = false;

  postInstall = ''
    install -Dm644 LICENSE -t $out/share/licenses/${finalAttrs.pname}/
    install -Dm644 THIRD-PARTY-NOTICES.md -t $out/share/licenses/${finalAttrs.pname}/
    install -Dm644 README.md -t $out/share/doc/${finalAttrs.pname}/

    install -Dm644 packaging/applications/zapfast.desktop \
      $out/share/applications/zapfast.desktop
    install -Dm644 packaging/icons/zapfast.svg \
      $out/share/icons/hicolor/scalable/apps/zapfast.svg

    if [ -f contrib/omarchy/zapfast.json.tpl ]; then
      install -Dm644 contrib/omarchy/zapfast.json.tpl \
        $out/share/zapfast/omarchy/zapfast.json.tpl
      install -Dm755 contrib/omarchy/zapfast-theme \
        $out/share/zapfast/omarchy/zapfast-theme
    fi
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast native WhatsApp client built with Rust and egui";
    homepage = "https://zapfast.rocks";
    changelog = "https://github.com/crmne/zapfast/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      mit
      gpl2Only
    ];
    maintainers = with lib.maintainers; [ cleboost ];
    mainProgram = "zapfast";
    platforms = lib.platforms.linux;
  };
})
