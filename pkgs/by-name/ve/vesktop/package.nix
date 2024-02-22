{ lib
, stdenv
, fetchFromGitHub
, fetchPnpmDeps
, pnpmConfigHook
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

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) src pname patches ELECTRON_SKIP_BINARY_DOWNLOAD;
    hash = "sha256-VQNJt4NvK4aYiiCEEkFSzv/cnmNAvjSDaSUFlaM+2pA=";
  };

  nativeBuildInputs = [
    pnpmConfigHook
    copyDesktopItems
    nodePackages.pnpm
    nodePackages.nodejs
    makeWrapper
  ];

  patches = [
    ./disable_update_checking.patch
  ] ++ lib.optional withSystemVencord (substituteAll { inherit vencord; src = ./use_system_vencord.patch; });

  ELECTRON_SKIP_BINARY_DOWNLOAD = 1;

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
        stdenv.cc.cc.lib
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
