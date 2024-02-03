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
, jq
, moreutils
, nodePackages
}:
stdenv.mkDerivation rec {
  pname = "vesktop";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "Vencord";
    repo = "Vesktop";
    rev = "v${version}";
    hash = "sha256-elgoX8z8q0+7uUia9gbcCmpDg+qYRWWUxdRuNV53Puw=";
  };

  pnpm-deps = stdenvNoCC.mkDerivation {
    pname = "${pname}-pnpm-deps";
    inherit src version patches ELECTRON_SKIP_BINARY_DOWNLOAD;

    nativeBuildInputs = [
      jq
      moreutils
      nodePackages.pnpm
    ];

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

    dontFixup = true;
    outputHashMode = "recursive";
    outputHash = "sha256-KDJ8QmpwGb2lOdwWEl5y62pJiqEvpI59StfQZrN1PPE=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    nodePackages.pnpm
    nodePackages.nodejs
    makeWrapper
  ];

  patches = [
    (substituteAll { inherit vencord; src = ./use_system_vencord.patch; })
  ];

  ELECTRON_SKIP_BINARY_DOWNLOAD = 1;

  preBuild = ''
    export HOME=$(mktemp -d)
    export STORE_PATH=$(mktemp -d)

    cp -r ${pnpm-deps}/* "$STORE_PATH"
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
  # yes, upstream really packages it as "vesktop" but uses "vencorddesktop" file names
  installPhase =
    let
      # this is mainly required for venmic
      libPath = lib.makeLibraryPath [
        libpulseaudio
        pipewire
        gcc13Stdenv.cc.cc.lib
      ];
    in
    ''
      runHook preInstall

      mkdir -p $out/opt/Vesktop/resources
      cp dist/linux-unpacked/resources/app.asar $out/opt/Vesktop/resources

      pushd build
      ${libicns}/bin/icns2png -x icon.icns
      for file in icon_*x32.png; do
        file_suffix=''${file//icon_}
        install -Dm0644 $file $out/share/icons/hicolor/''${file_suffix//x32.png}/apps/vencorddesktop.png
      done

      makeWrapper ${electron}/bin/electron $out/bin/vencorddesktop \
        --prefix LD_LIBRARY_PATH : ${libPath} \
        --add-flags $out/opt/Vesktop/resources/app.asar \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"

      runHook postInstall
    '';

  desktopItems = [
    (makeDesktopItem {
      name = "vencorddesktop";
      desktopName = "Vesktop";
      exec = "vencorddesktop %U";
      icon = "vencorddesktop";
      startupWMClass = "VencordDesktop";
      genericName = "Internet Messenger";
      keywords = [ "discord" "vencord" "electron" "chat" ];
    })
  ];

  meta = with lib; {
    description = "An alternate client for Discord with Vencord built-in";
    homepage = "https://github.com/Vencord/Vesktop";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ getchoo Scrumplex vgskye ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    mainProgram = "vencorddesktop";
    broken = stdenv.hostPlatform.isAarch64;
  };
}
