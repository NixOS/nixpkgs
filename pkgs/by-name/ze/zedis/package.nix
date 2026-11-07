{
  pkg-config,
  makeWrapper,

  libxcb,
  libxkbcommon,
  wayland,
  vulkan-loader,
  fontconfig,
  zstd,
  openssl,

  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zedis";
  version = "0.15.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "vicanso";
    repo = "zedis";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JGrrz3FTCZPuHMirTq2ifcT26GKuaHPO2YYenkC5els=";
  };

  cargoHash = "sha256-YpkUzEa/PBpLTPhJpgtfWnGSuWvpUWQcfgBqBLXzdCo=";

  env.ZSTD_SYS_USE_PKG_CONFIG = true;
  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];
  buildInputs = [
    zstd
    libxkbcommon
    libxcb
    fontconfig
    openssl
  ];

  postInstall = ''
    install -Dm644 assets/zedis.desktop \
      $out/share/applications/zedis.desktop
    install -Dm644 assets/icon.png \
      $out/share/icons/hicolor/256x256/apps/zedis.png
  '';

  postFixup = ''
    wrapProgram $out/bin/zedis \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          vulkan-loader
          wayland
        ]
      }
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Blazing-fast, native Redis GUI built with Rust and GPUI";
    homepage = "https://github.com/vicanso/zedis";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ oriionn ];
    mainProgram = "zedis";
    platforms = lib.platforms.linux;
  };
})
