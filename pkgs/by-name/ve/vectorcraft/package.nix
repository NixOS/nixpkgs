{
  lib,
  stdenv,
  rustPlatform,
  rustc,
  versionCheckHook,
  fetchFromGitHub,
  pkg-config,
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
  runtimeDeps = [
    libxkbcommon
    libx11
    libxcb
    libxcursor
    libxi
    wayland
    vulkan-loader
    libxrandr
    dbus
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vectorcraft";
  version = "0.22.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "storytold";
    repo = "vectorcraft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4Cb7wS6IxhGsQ8O4CdbjDJtYu8Z3NoHhUzxbRWziYYA=";
  };

  cargoHash = "sha256-wXaN0TDkhMT6SgOH5HO1NSVsvB3vT1bghEomOF3BYkc=";

  cargoBuildFlags = [
    "--package=vectorcraft"
    "--package=vectorcraft-cli"
  ];

  env = {
    CRAFT_FONTS_DIR = craft-fonts;
    CRAFT_FONTS_REQUIRED = "1";
  };

  # The `vectorcraft` crate runs live GPU tests; software rendering in CI is too slow.
  cargoTestFlags = [
    "--package=vectorcraft-cli"
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  # [[patch.unused]] egui fork entries in Cargo.toml break cargo --offline in the sandbox.
  postPatch = ''
    sed -i -E '/^(egui_demo_lib|egui_inspection|egui_system_font_provider) = /d' Cargo.toml
  '';

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm644 packaging/linux/ai.storyteller.vectorcraft.desktop \
      $out/share/applications/ai.storyteller.vectorcraft.desktop
    install -Dm644 packaging/linux/ai.storyteller.vectorcraft.mime.xml \
      $out/share/mime/packages/ai.storyteller.vectorcraft.xml
    mkdir -p $out/share/icons
    cp -R assets/app-icon/hicolor $out/share/icons/
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf --add-rpath ${lib.makeLibraryPath runtimeDeps} $out/bin/vectorcraft
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Vector illustration, a native Illustrator-style editor for SVG and PDF";
    homepage = "https://github.com/storytold/vectorcraft";
    changelog = "https://github.com/storytold/vectorcraft/releases/tag/${finalAttrs.src.tag}";
    license =
      with lib.licenses;
      AND [
        (OR [
          mit
          asl20
        ])
        ofl
      ];
    maintainers = with lib.maintainers; [ cleboost ];
    mainProgram = "vectorcraft";
    platforms = rustc.meta.platforms;
  };
})
