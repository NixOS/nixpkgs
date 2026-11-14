{
  lib,
  stdenv,
  rustPlatform,
  rustc,
  fetchFromGitHub,
  pkg-config,
  patchelf,
  versionCheckHook,
  vulkan-loader,
  libxkbcommon,
  libx11,
  libxcb,
  libxcursor,
  libxi,
  libxrandr,
  wayland,
  dbus,
  aws-lc,
  craft-fonts,
  craft-i18n,

  nix-update-script,
}:

let
  # Loaded with dlopen by winit, wgpu and rfd (libdbus, for the file dialogs).
  runtimeDeps = [
    libxkbcommon
    libx11
    libxcb
    libxcursor
    libxi
    libxrandr
    wayland
    vulkan-loader
    dbus
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wordcraft";
  version = "0.18.1";

  __structuredAttrs = true;
  strictDeps = true;

  env = {
    CRAFT_FONTS_DIR = craft-fonts;
    CRAFT_FONTS_REQUIRED = "1";
    CRAFT_I18N_DIR = craft-i18n;
    CRAFT_I18N_REQUIRED = "1";
  };

  src = fetchFromGitHub {
    owner = "storytold";
    repo = "wordcraft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-n8BQIiX6C3D8pd8pil/reM/ffSW+cPEsI/OuQSUrYus=";
  };

  cargoHash = "sha256-gsiSbjdpjKKtWfYr2xcyLiGWamy7qGGSKOraRvnaVAM=";

  postPatch = ''
    sed -i -E '/^(egui_demo_lib|egui_inspection|egui_system_font_provider) = /d' Cargo.toml
  '';

  cargoBuildFlags = [
    "--package=wordcraft"
    "--package=wordcraft-cli"
  ];

  cargoTestFlags = [
    "--package=wordcraft-cli"
  ];

  # The wordcraft-zotero tests talk to a fake Zotero over a loopback TCP socket.
  __darwinAllowLocalNetworking = true;

  nativeBuildInputs = [
    pkg-config
    patchelf
  ];

  buildInputs = [ aws-lc ];

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir -p $out/share/icons
    cp -R assets/app-icon/hicolor $out/share/icons/
    install -Dm644 packaging/linux/ai.storyteller.wordcraft.desktop \
      $out/share/applications/ai.storyteller.wordcraft.desktop
    install -Dm644 packaging/linux/ai.storyteller.wordcraft.mime.xml \
      $out/share/mime/packages/ai.storyteller.wordcraft.xml
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf --add-rpath ${lib.makeLibraryPath runtimeDeps} $out/bin/wordcraft
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Word processor with DOCX, ODT and RTF support";
    homepage = "https://github.com/storytold/wordcraft";
    changelog = "https://github.com/storytold/wordcraft/releases/tag/${finalAttrs.src.tag}";
    # Bundled fonts and hyphenation data: see ATTRIBUTION.md in upstream.
    license =
      with lib.licenses;
      AND [
        (OR [
          mit
          asl20
        ])
        ofl
        cc0
        publicDomain
      ];
    maintainers = with lib.maintainers; [ sophronesis ];
    mainProgram = "wordcraft";
    platforms = rustc.meta.platforms;
  };
})
