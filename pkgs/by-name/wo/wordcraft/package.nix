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
  craft-fonts,

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
  version = "0.13.2";

  __structuredAttrs = true;
  strictDeps = true;

  env = {
    CRAFT_FONTS_DIR = "${craft-fonts}";
    CRAFT_FONTS_REQUIRED = "1";
  };

  src = fetchFromGitHub {
    owner = "storytold";
    repo = "wordcraft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Y+lVmOeuZHovomHqi1z/15v9GGxaOs6HxD8PmRzBOY4=";
  };

  cargoHash = "sha256-nPgPlmWlzTAExqGue06uAmeanMNssPlFCzH9W41dceI=";

  # [[patch.unused]] in Cargo.lock: cargo --offline validates every [patch.crates-io] line
  # against the git tree, but fetchCargoVendor only vendors crates in the dependency graph.
  postPatch = ''
    substituteInPlace Cargo.toml \
      --replace-fail $'egui_demo_lib = { git = "https://github.com/storytold/egui.git", rev = "6d518fc799681571963842f95b55a6b68431b15a" }\n' "" \
      --replace-fail $'egui_inspection = { git = "https://github.com/storytold/egui.git", rev = "6d518fc799681571963842f95b55a6b68431b15a" }\n' "" \
      --replace-fail $'egui_extras = { git = "https://github.com/storytold/egui.git", rev = "6d518fc799681571963842f95b55a6b68431b15a" }\n' "" \
      --replace-fail $'egui_system_font_provider = { git = "https://github.com/storytold/egui.git", rev = "6d518fc799681571963842f95b55a6b68431b15a" }\n' ""
  '';

  cargoBuildFlags = [
    "--package=wordcraft"
    "--package=wordcraft-cli"
  ];

  # wordcraft-pdf and wordcraft-layout tests are flaky/slow in the Nix sandbox.
  cargoTestFlags = [
    "--package=wordcraft-cli"
  ];

  # The wordcraft-zotero tests talk to a fake Zotero over a loopback TCP socket.
  __darwinAllowLocalNetworking = true;

  nativeBuildInputs = [
    pkg-config
    patchelf
  ];

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
