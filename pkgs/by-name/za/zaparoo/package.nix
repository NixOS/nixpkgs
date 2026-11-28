{
  lib,
  alsa-lib,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
  fetchurl,
  stdenv,
  versionCheckHook,
  nix-update-script,
  pcsclite,
  pkg-config,
  libusb1,
  libnfc,
  libpulseaudio,
  sqlite,
}:

buildGoModule (finalAttrs: {
  pname = "zaparoo";
  version = "2.23.1";

  src = fetchFromGitHub {
    owner = "ZaparooProject";
    repo = "zaparoo-core";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CRsN1H63IdrukVtGWGefjOfLOqCcTEaey7w2QBlulBs=";
  };

  patches = [
  ];

  vendorHash = "sha256-Cc1FkZrH9pfm4gUKCPOxrrbbQZPJCfp8/18fn/4hSi8=";

  webUIVersion = "2.0.3";
  webUI = fetchurl {
    url = "https://github.com/ZaparooProject/zaparoo-app/releases/download/v${finalAttrs.webUIVersion}/zaparoo_app-web-core-${finalAttrs.webUIVersion}.tar.gz";
    hash = "sha256-zC0oWgelAp4Hkh0s9CRcsF82fe2iVHm7zSbWKZ/doyM=";
  };

  subPackages = [ (if stdenv.hostPlatform.isDarwin then "cmd/mac" else "cmd/linux") ];

  tags = [
    "libsqlite3"
    "netgo"
    "osusergo"
    "sqlite_omit_load_extension"
    "validator_novalidatefn"
    "expr_static_methods"
  ];

  ldflags = [
    "-s"
    "-X github.com/ZaparooProject/zaparoo-core/v2/pkg/config.AppVersion=${finalAttrs.version}"
    "-X github.com/ZaparooProject/zaparoo-core/v2/pkg/config.PackageManaged=true"
  ];

  env.CGO_ENABLED = 1;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    sqlite
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libusb1
    libnfc
  ];

  postPatch = ''
    mkdir -p pkg/assets/_app/dist
    tar xf ${finalAttrs.webUI} -C pkg/assets/_app/dist/
  '';

  postConfigure = ''
    go run ./scripts/compress-app
  '';

  postInstall = ''
    mv $out/bin/${if stdenv.hostPlatform.isDarwin then "mac" else "linux"} $out/bin/zaparoo
  '';

  # Loaded with dlopen: PC/SC for CCID readers, ALSA and PulseAudio for sounds
  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf $out/bin/zaparoo \
      --add-rpath ${
        lib.makeLibraryPath [
          alsa-lib
          libpulseaudio
          pcsclite
        ]
      }
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Launch games and cores on your MiSTer, emulators and handhelds using NFC tags or cards";
    homepage = "https://zaparoo.org/";
    changelog = "https://github.com/ZaparooProject/zaparoo-core/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ liberodark ];
    mainProgram = "zaparoo";
  };
})
