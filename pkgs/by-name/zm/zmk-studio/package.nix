{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchNpmDeps,
  npm-lockfile-fix,

  cargo-tauri,
  makeBinaryWrapper,
  nodejs,
  npmHooks,
  pkg-config,
  wrapGAppsHook3,

  glib-networking,
  udev,
  webkitgtk_4_1,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zmk-studio";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "zmkfirmware";
    repo = "zmk-studio";
    tag = "v${finalAttrs.version}";

    postFetch = ''
      # add missing integrity fields to lockfile
      ${lib.getExe npm-lockfile-fix} $out/package-lock.json
    '';

    hash = "sha256-7UwY+272JNqzQf1juOzDkiW2DNKHC5xg4cGguwAgwNc=";
  };

  patches = [
    ./darwin-dont-sign.patch
  ];

  # building the download page requires the app to fetch the github API at build-time
  # this page would only ever be visited if it wasn't built with tauri, so we disable it instead
  postPatch = ''
    # turn `npm run generate-data` into a NOOP
    substituteInPlace package.json \
      --replace-fail '"generate-data": "' '"generate-data": "true || '

    # remove download page
    rm download.html src/download.tsx src/DownloadPage.tsx
    substituteInPlace vite.config.ts \
      --replace-fail 'download: "./download.html",' ""
  '';

  cargoRoot = "src-tauri";
  buildAndTestSubdir = "src-tauri";

  cargoHash = "sha256-BNX2vhsHaSk3eiadVPH6To0CgbOEGJ1JVKkW3Hw7QH0=";

  npmDeps = fetchNpmDeps {
    name = "zmk-studio-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src patches;
    hash = "sha256-htCqTX/w1GP3b8wBD9p60Lwpjr2V7sv05unRv2IrP1A=";
  };

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    npmHooks.npmConfigHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    pkg-config
    wrapGAppsHook3
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    makeBinaryWrapper
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    glib-networking # for image loading
    udev
    webkitgtk_4_1
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    makeWrapper "$out/Application/ZMK Studio.app/Contents/MacOS/zmk-studio" "$out/bin/zmk-studio"
  '';

  meta = {
    description = "Tool for runtime keymap updates on ZMK-powered devices without reflashing firmware";
    homepage = "https://github.com/zmkfirmware/zmk-studio";
    changelog = "https://github.com/zmkfirmware/zmk-studio/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    mainProgram = "zmk-studio";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
