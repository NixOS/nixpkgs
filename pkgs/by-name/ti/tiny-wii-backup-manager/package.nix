{
  lib,
  fetchFromGitHub,
  rustPlatform,
  makeWrapper,
  pkg-config,

  dbus,
  fontconfig,
  libGL,
  libx11,
  libxcb,
  libxcursor,
  libxext,
  libxi,
  libxinerama,
  libxkbcommon,
  libxrandr,
  openssl,
  vulkan-loader,
  wayland,
  xdg-utils,
  zenity,

  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tiny-wii-backup-manager";
  version = "6.0.7";

  src = fetchFromGitHub {
    owner = "mq1";
    repo = "TinyWiiBackupManager";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yvmLI8T+ut0QwnHPw+0+XKvd+wWo0cJLcxSkz3oj/vE=";
  };

  cargoHash = "sha256-/Q0P3re8w9O4a8MTZXmEiaJNURo1XeZhHk8adcUCNeQ=";

  cargoBuildFlags = [
    "--bin"
    "twbm-gui"
  ];

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    dbus
    fontconfig
    libGL
    libx11
    libxcb
    libxcursor
    libxext
    libxi
    libxinerama
    libxkbcommon
    libxrandr
    openssl
    vulkan-loader
    wayland
  ];

  # Upstream does not currently ship tests.
  doCheck = false;

  postInstall = ''
    mv $out/bin/twbm-gui $out/bin/TinyWiiBackupManager

    install -Dm644 package/linux/AppDir/usr/share/applications/it.mq1.TinyWiiBackupManager.desktop \
      $out/share/applications/it.mq1.TinyWiiBackupManager.desktop
    install -Dm644 package/linux/it.mq1.TinyWiiBackupManager.metainfo.xml \
      $out/share/metainfo/it.mq1.TinyWiiBackupManager.metainfo.xml

    mkdir -p $out/share/icons
    cp -r package/linux/AppDir/usr/share/icons/hicolor $out/share/icons/

    wrapProgram $out/bin/TinyWiiBackupManager \
      --prefix PATH : ${
        lib.makeBinPath [
          xdg-utils
          zenity
        ]
      } \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          dbus
          fontconfig
          libGL
          libx11
          libxcb
          libxcursor
          libxext
          libxi
          libxinerama
          libxkbcommon
          libxrandr
          openssl
          vulkan-loader
          wayland
        ]
      }
  '';

  passthru.updateScript = nix-update-script { };

  __structuredAttrs = true;

  meta = {
    description = "Tiny game backup and homebrew app manager for the Wii";
    homepage = "https://github.com/mq1/TinyWiiBackupManager";
    changelog = "https://github.com/mq1/TinyWiiBackupManager/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ yisraeldov ];
    mainProgram = "TinyWiiBackupManager";
    platforms = lib.platforms.linux;
  };
})
