{
  lib,
  rustPlatform,
  fetchFromGitHub,
  copyDesktopItems,
  makeDesktopItem,
  pkg-config,
  openssl,
  sqlcipher,
  wayland,
  libxkbcommon,
  vulkan-loader,
  fontconfig,
  freetype,
  libx11,
  libxcb,
  libxcb-util,
  libGL,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "zorite";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "packetThrower";
    repo = "zorite";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kJSqBA6dnlFQQkadJ98+GcISJKTOyalTDamD+87pBsc=";
  };

  # Covers the crates.io and git dependencies (gpui and friends) in one hash.
  cargoHash = "sha256-7yHJWyyrXlmHGKywm3lcPqnstwKO1BmaXqazuIjLOvo=";

  nativeBuildInputs = [
    pkg-config
    copyDesktopItems
  ];

  buildInputs = [
    # cargoSetupHook makes rusqlite link these instead of its bundled
    # SQLCipher and vendored OpenSSL.
    openssl
    sqlcipher
    wayland
    libxkbcommon
    fontconfig
    freetype
    libx11
    libxcb
    libxcb-util
  ];

  postFixup = ''
    # gpui dlopens Vulkan and the Wayland/X11 client libraries at runtime
    # rather than linking them; libGL lets wgpu fall back to OpenGL when
    # Vulkan is unavailable.
    patchelf --add-rpath ${
      lib.makeLibraryPath [
        libGL
        wayland
        libxkbcommon
        vulkan-loader
      ]
    } $out/bin/zorite
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "zorite";
      desktopName = "Zorite";
      comment = "Local-first Markdown daily journal";
      exec = "zorite";
      icon = "zorite";
      categories = [ "Office" ];
    })
  ];

  postInstall = ''
    install -Dm644 resources/icons/icon.png \
      $out/share/icons/hicolor/512x512/apps/zorite.png
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Local-first, Markdown daily-journal desktop app with wiki-links, whiteboards, and PDF annotation";
    homepage = "https://packetthrower.github.io/zorite/";
    changelog = "https://github.com/packetThrower/zorite/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ packetThrower ];
    mainProgram = "zorite";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
