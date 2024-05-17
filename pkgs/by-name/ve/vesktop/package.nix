{
  lib,
  stdenv,
  fetchFromGitHub,
  substituteAll,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  vencord,
  electron,
  libicns,
  pipewire,
  libpulseaudio,
  autoPatchelfHook,
  pnpm,
  nodejs,
  withTTS ? true,
  # Enables the use of vencord from nixpkgs instead of
  # letting vesktop manage it's own version
  withSystemVencord ? false,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "vesktop";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "Vencord";
    repo = "Vesktop";
    rev = "v${finalAttrs.version}";
    hash = "sha256-cZOyydwpIW9Xq716KVi1RGtSlgVnOP3w8vXDwouS70E=";
  };

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src patches;
    hash = "sha256-PogE8uf3W5cKSCqFHMz7FOvT7ONUP4FiFWGBgtk3UC8=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    makeWrapper
    nodejs
    pnpm.configHook
  ];

  buildInputs = [
    libpulseaudio
    pipewire
    stdenv.cc.cc.lib
  ];

  patches =
    [ ./disable_update_checking.patch ]
    ++ lib.optional withSystemVencord (substituteAll {
      inherit vencord;
      src = ./use_system_vencord.patch;
    });

  ELECTRON_SKIP_BINARY_DOWNLOAD = 1;

  buildPhase = ''
    runHook preBuild

    pnpm build
    # using `pnpm exec` here apparently makes it ignore ELECTRON_SKIP_BINARY_DOWNLOAD
    ./node_modules/.bin/electron-builder \
      --dir \
      -c.asarUnpack="**/*.node" \
      -c.electronDist=${electron}/libexec/electron \
      -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  # this is consistent with other nixpkgs electron packages and upstream, as far as I am aware
  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/Vesktop
    cp -r dist/linux-*unpacked/resources $out/opt/Vesktop/

    pushd build
    ${libicns}/bin/icns2png -x icon.icns
    for file in icon_*x32.png; do
      file_suffix=''${file//icon_}
      install -Dm0644 $file $out/share/icons/hicolor/''${file_suffix//x32.png}/apps/vesktop.png
    done

    makeWrapper ${electron}/bin/electron $out/bin/vesktop \
      --add-flags $out/opt/Vesktop/resources/app.asar \
      ${lib.optionalString withTTS "--add-flags \"--enable-speech-dispatcher\""} \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime}}"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "vesktop";
      desktopName = "Vesktop";
      exec = "vesktop %U";
      icon = "vesktop";
      startupWMClass = "Vesktop";
      genericName = "Internet Messenger";
      keywords = [
        "discord"
        "vencord"
        "electron"
        "chat"
      ];
      categories = [
        "Network"
        "InstantMessaging"
        "Chat"
      ];
    })
  ];

  passthru = {
    inherit (finalAttrs) pnpmDeps;
  };

  meta = {
    description = "An alternate client for Discord with Vencord built-in";
    homepage = "https://github.com/Vencord/Vesktop";
    changelog = "https://github.com/Vencord/Vesktop/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      getchoo
      Scrumplex
      vgskye
      pluiedev
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "vesktop";
  };
})
