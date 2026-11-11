{
  lib,
  fetchFromGitHub,
  aws-lc,
  libx11,
  libxcb,
  libxcursor,
  libxi,
  libxkbcommon,
  makeBinaryWrapper,
  nix-update-script,
  openssl,
  pkg-config,
  rustPlatform,
  vulkan-loader,
  wayland,
  xdg-utils,
  zenity,
  zstd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tiny-wii-backup-manager";
  version = "6.2.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "mq1";
    repo = "TinyWiiBackupManager";
    tag = "v${finalAttrs.version}";
    hash = "sha256-df4MYTBiDDaFNfCakJ68Xjjnvbw23zixoSi9ZW5F7Js=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    pkg-config
  ];

  buildInputs = [
    aws-lc
    openssl
    zstd
  ];

  cargoHash = "sha256-ljildHQccDyZlbJyrS38FZLY2bgDomkwHHTAJ6JdHQ4=";

  # Upstream does not currently ship tests.
  doCheck = false;

  postInstall = ''
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
          libx11
          libxcb
          libxcursor
          libxi
          libxkbcommon
          vulkan-loader
          wayland
        ]
      }
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tiny game backup and homebrew app manager for the Wii";
    homepage = "https://github.com/mq1/TinyWiiBackupManager";
    changelog = "https://github.com/mq1/TinyWiiBackupManager/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ yisraeldov ];
    platforms = lib.platforms.linux;
    mainProgram = "TinyWiiBackupManager";
  };
})
