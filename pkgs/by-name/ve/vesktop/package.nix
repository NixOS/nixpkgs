{ lib
, stdenv
, stdenvNoCC
, gcc13Stdenv
, fetchFromGitHub
, substituteAll
, makeWrapper
, makeDesktopItem
, copyDesktopItems
, vencord
, electron
, pipewire
, libpulseaudio
, libicns
, libnotify
, jq
, moreutils
, cacert
, nodePackages
, speechd
, withTTS ? true
  # Enables the use of vencord from nixpkgs instead of
  # letting vesktop manage it's own version
, withSystemVencord ? true
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "vesktop";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "Vencord";
    repo = "Vesktop";
    rev = "v${finalAttrs.version}";
    hash = "sha256-27998q9wbaNP1xYY+KHTBeJRfR6Q/K0LNdbRb3YHC6c=";
  };

  # NOTE: This requires pnpm 8.10.0 or newer
  # https://github.com/pnpm/pnpm/pull/7214
  pnpmDeps =
    assert lib.versionAtLeast nodePackages.pnpm.version "8.10.0";
    stdenvNoCC.mkDerivation {
      pname = "${finalAttrs.pname}-pnpm-deps";
      inherit (finalAttrs) src version patches ELECTRON_SKIP_BINARY_DOWNLOAD;

      nativeBuildInputs = [
        jq
        moreutils
        nodePackages.pnpm
        cacert
      ];

      pnpmPatch = builtins.toJSON {
        pnpm.supportedArchitectures = {
          os = [ "linux" ];
          cpu = [ "x64" "arm64" ];
        };
      };

      postPatch = ''
        mv package.json package.json.orig
        jq --raw-output ". * $pnpmPatch" package.json.orig > package.json
      '';

      # https://github.com/NixOS/nixpkgs/blob/763e59ffedb5c25774387bf99bc725df5df82d10/pkgs/applications/misc/pot/default.nix#L56
      installPhase = ''
        export HOME=$(mktemp -d)

        pnpm config set store-dir $out
        pnpm install --frozen-lockfile --ignore-script

        rm -rf $out/v3/tmp
        for f in $(find $out -name "*.json"); do
          sed -i -E -e 's/"checkedAt":[0-9]+,//g' $f
          jq --sort-keys . $f | sponge $f
        done
      '';

      dontBuild = true;
      dontFixup = true;
      outputHashMode = "recursive";
      outputHash = "sha256-cnk+KFdvsgG1wGDib7zgIS6/RkrR5EYAHtHcrFSU0Es=";
    };

  nativeBuildInputs = [
    copyDesktopItems
    nodePackages.pnpm
    nodePackages.nodejs
    makeWrapper
  ];

  patches = [
    ./disable_update_checking.patch
  ] ++ lib.optional withSystemVencord (substituteAll { inherit vencord; src = ./use_system_vencord.patch; });

  ELECTRON_SKIP_BINARY_DOWNLOAD = 1;

  preBuild = ''
    export HOME=$(mktemp -d)
    export STORE_PATH=$(mktemp -d)

    cp -Tr "$pnpmDeps" "$STORE_PATH"
    chmod -R +w "$STORE_PATH"

    pnpm config set store-dir "$STORE_PATH"
    pnpm install --offline --frozen-lockfile --ignore-script
    patchShebangs node_modules/{*,.*}
  '';

  postBuild = ''
    pnpm build
    # using `pnpm exec` here apparently makes it ignore ELECTRON_SKIP_BINARY_DOWNLOAD
    ./node_modules/.bin/electron-builder \
      --dir \
      -c.electronDist=${electron}/libexec/electron \
      -c.electronVersion=${electron.version}
  '';

  # this is consistent with other nixpkgs electron packages and upstream, as far as I am aware
  installPhase =
    let
      # this is mainly required for venmic
      libPath = lib.makeLibraryPath ([
        libpulseaudio
        libnotify
        pipewire
        gcc13Stdenv.cc.cc.lib
      ] ++ lib.optional withTTS speechd);
    in
    ''
      runHook preInstall

      mkdir -p $out/opt/Vesktop/resources
      cp dist/linux-*unpacked/resources/app.asar $out/opt/Vesktop/resources

      pushd build
      ${libicns}/bin/icns2png -x icon.icns
      for file in icon_*x32.png; do
        file_suffix=''${file//icon_}
        install -Dm0644 $file $out/share/icons/hicolor/''${file_suffix//x32.png}/apps/vesktop.png
      done

      makeWrapper ${electron}/bin/electron $out/bin/vesktop \
        --prefix LD_LIBRARY_PATH : ${libPath} \
        --add-flags $out/opt/Vesktop/resources/app.asar \
        ${lib.optionalString withTTS "--add-flags \"--enable-speech-dispatcher\""} \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"

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
      keywords = [ "discord" "vencord" "electron" "chat" ];
      categories = [ "Network" "InstantMessaging" "Chat" ];
    })
  ];

  passthru = {
    inherit (finalAttrs) pnpmDeps;
  };

  meta = with lib; {
    description = "An alternate client for Discord with Vencord built-in";
    homepage = "https://github.com/Vencord/Vesktop";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ getchoo Scrumplex vgskye pluiedev ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    mainProgram = "vesktop";
  };
})
