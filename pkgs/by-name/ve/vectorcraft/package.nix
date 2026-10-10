{
  lib,
  stdenv,
  rustPlatform,
  rustc,
  versionCheckHook,
  fetchFromGitHub,
  pkg-config,
  patchelf,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  vulkan-loader,
  libxkbcommon,
  libx11,
  libxcb,
  libxcursor,
  libxi,
  libxrandr,
  wayland,
  dbus,
  craftFonts,

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
  version = "0.8.0";

  __structuredAttrs = true;
  strictDeps = true;

  env = {
    CRAFT_FONTS_DIR = "${craftFonts}";
    CRAFT_FONTS_REQUIRED = "1";
  };

  src = fetchFromGitHub {
    owner = "storytold";
    repo = "vectorcraft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2hBWnpy4ugegIJweyydp7E9HKQ+u+LtbFvGnbAtgFAI=";
  };

  cargoHash = "sha256-mCTuARKTk/8Dhiefool5VAUlYEM+tSu4tkUTnmlKaLY=";

  cargoBuildFlags = [
    "--package=vectorcraft"
    "--package=vectorcraft-cli"
  ];

  # The `vectorcraft` crate runs live GPU tests; software rendering in CI is too slow.
  cargoTestFlags = [
    "--package=vectorcraft-cli"
  ];

  nativeBuildInputs = [
    pkg-config
    patchelf
    makeWrapper
    copyDesktopItems
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "ai.storyteller.vectorcraft";
      desktopName = "VectorCraft";
      genericName = "Vector Editor";
      comment = "Vector illustration, a native Illustrator-style editor for SVG and PDF";
      exec = "vectorcraft %F";
      tryExec = "vectorcraft";
      icon = "ai.storyteller.vectorcraft";
      terminal = false;
      startupWMClass = "vectorcraft";
      keywords = [
        "vector"
        "illustration"
        "svg"
        "pdf"
        "drawing"
        "bezier"
      ];
      mimeTypes = [
        "image/svg+xml"
        "application/pdf"
      ];
      categories = [ "Graphics" ];
    })
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir -p $out/share/icons
    cp -R assets/app-icon/hicolor $out/share/icons/

    docdir=$out/share/doc/${finalAttrs.pname}-${finalAttrs.version}
    install -d $docdir
    for lic in ${craftFonts}/fonts/*/OFL.txt; do
      install -Dm644 "$lic" "$docdir/OFL-$(basename "$(dirname "$lic")").txt"
    done
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf --add-rpath ${lib.makeLibraryPath runtimeDeps} $out/bin/vectorcraft
    wrapProgram $out/bin/vectorcraft --set VECTORCRAFT_SKIP_LIB_CHECK 1
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Vector illustration, a native Illustrator-style editor for SVG and PDF";
    homepage = "https://github.com/storytold/vectorcraft";
    changelog = "https://github.com/storytold/vectorcraft/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.OR [
      lib.licenses.mit
      lib.licenses.asl20
    ];
    maintainers = with lib.maintainers; [ cleboost ];
    mainProgram = "vectorcraft";
    platforms = rustc.meta.platforms;
  };
})
