{
  lib,
  stdenv,
  stdenvNoCC,
  fetchFromGitHub,
  substituteAll,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  vencord,
  electron,
  libicns,
  jq,
  moreutils,
  cacert,
  nodePackages,
  pipewire,
  libpulseaudio,
  autoPatchelfHook,
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

  # NOTE: This requires pnpm 8.10.0 or newer
  # https://github.com/pnpm/pnpm/pull/7214
  pnpmDeps =
    assert lib.versionAtLeast nodePackages.pnpm.version "8.10.0";
    stdenvNoCC.mkDerivation {
      pname = "${finalAttrs.pname}-pnpm-deps";
      inherit (finalAttrs)
        src
        version
        patches
        ELECTRON_SKIP_BINARY_DOWNLOAD
        ;

      nativeBuildInputs = [
        cacert
        jq
        moreutils
        nodePackages.pnpm
      ];

      # inspired by https://github.com/NixOS/nixpkgs/blob/763e59ffedb5c25774387bf99bc725df5df82d10/pkgs/applications/misc/pot/default.nix#L56
      # and based on https://github.com/NixOS/nixpkgs/pull/290715
      installPhase = ''
        runHook preInstall

        export HOME=$(mktemp -d)
        pnpm config set store-dir $out
        # Some packages produce platform dependent outputs. We do not want to cache those in the global store
        pnpm config set side-effects-cache false
        # pnpm is going to warn us about using --force
        # --force allows us to fetch all dependencies including ones that aren't meant for our host platform
        pnpm install --force --frozen-lockfile --ignore-script

      '';

      fixupPhase = ''
        runHook preFixup

        # Remove timestamp and sort the json files
        rm -rf $out/v3/tmp
        for f in $(find $out -name "*.json"); do
          sed -i -E -e 's/"checkedAt":[0-9]+,//g' $f
          jq --sort-keys . $f | sponge $f
        done

        runHook postFixup
      '';

      dontConfigure = true;
      dontBuild = true;
      outputHashMode = "recursive";
      outputHash = "sha256-PogE8uf3W5cKSCqFHMz7FOvT7ONUP4FiFWGBgtk3UC8=";
    };

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    makeWrapper
    nodePackages.pnpm
    nodePackages.nodejs
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

  configurePhase = ''
    runHook preConfigure

    export HOME=$(mktemp -d)
    export STORE_PATH=$(mktemp -d)

    cp -Tr "$pnpmDeps" "$STORE_PATH"
    chmod -R +w "$STORE_PATH"

    pnpm config set store-dir "$STORE_PATH"
    pnpm install --frozen-lockfile --ignore-script --offline
    patchShebangs node_modules/{*,.*}

    runHook postConfigure
  '';

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
