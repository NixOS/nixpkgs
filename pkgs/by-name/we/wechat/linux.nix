{
  lib,
  stdenv,
  stdenvNoCC,
  fetchurl,

  # native
  autoPatchelfHook,
  dpkg,
  makeShellWrapper,
  wrapGAppsHook3,

  # runtime
  alsa-lib,
  at-spi2-core,
  bzip2,
  cairo,
  cups,
  dbus,
  expat,
  fontconfig,
  glib,
  gtk3,
  libredirect,
  libice,
  libsm,
  libx11,
  libxcomposite,
  libxcursor,
  libxdamage,
  libxext,
  libxfixes,
  libxrandr,
  libglvnd,
  libjack2,
  libpulseaudio,
  libxcb,
  libxcb-keysyms,
  libxkbcommon,
  mesa,
  nspr,
  nss,
  pango,
  pipewire,
  systemd,
  util-linuxMinimal,
  wayland,
  xkeyboard-config,
  zlib,

  pname,
  passthru,
  meta,
  ...
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  inherit pname;

  inherit (finalAttrs.passthru.source) version;
  src = fetchurl finalAttrs.passthru.source.src;

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeShellWrapper
    wrapGAppsHook3
  ];

  buildInputs = [
    (lib.getLib stdenv.cc.cc) # for libatomic, libstdc++

    dbus
    glib
    systemd # for libudev

    at-spi2-core
    cairo
    fontconfig
    gtk3
    libxkbcommon
    xkeyboard-config
    pango

    libice
    libsm
    libx11
    libxcomposite
    libxcursor
    libxdamage
    libxext
    libxfixes
    libxrandr
    libxcb
    libxcb-keysyms

    wayland

    libglvnd
    mesa # for libgbm

    alsa-lib
    libjack2
    libpulseaudio
    pipewire

    cups

    nspr
    nss

    bzip2
    expat
    zlib
  ];

  runtimeDependencies = [
    alsa-lib
    gtk3
    libglvnd
    libpulseaudio
    libxcursor
    pipewire
    systemd
    wayland
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    cp -r opt "$out/"
    cp -r usr/share "$out/"

    substituteInPlace "$out/share/applications/wechat.desktop" \
      --replace-fail "/usr/bin/wechat" "wechat" \
      --replace-fail "/usr/share/icons/hicolor/256x256/apps/wechat.png" "wechat"

    runHook postInstall
  '';

  dontWrapGApps = true;

  preFixup = ''
    # Bundled Qt 5 cannot position IME candidate popups under native Wayland.
    makeShellWrapper "$out/opt/wechat/wechat" "$out/bin/wechat" \
      "''${gappsWrapperArgs[@]}" \
      --set LD_PRELOAD "${libredirect}/lib/libredirect.so" \
      --set NIX_REDIRECTS "/usr/bin/lsblk=${lib.getExe' util-linuxMinimal "lsblk"}" \
      --set XKB_CONFIG_ROOT "${xkeyboard-config}/share/X11/xkb" \
      --set XLOCALEDIR "${libx11}/share/X11/locale" \
      --set QT_QPA_PLATFORM "xcb" \
      --set-default QT_AUTO_SCREEN_SCALE_FACTOR "1" \
      --run '
        if [ -z "''${QT_IM_MODULE:-}" ]; then
          case "''${XMODIFIERS:-}" in
            *fcitx*)
              export QT_IM_MODULE=fcitx
              ;;
            *ibus*)
              export QT_IM_MODULE=ibus
              export IBUS_USE_PORTAL=1
              ;;
          esac
        fi
      '
  '';

  postFixup = ''
    # ANGLE loads libGL.so.1 dynamically from the GPU process.
    patchelf --add-needed "${libglvnd}/lib/libGL.so.1" \
      "$out/opt/wechat/RadiumWMPF/runtime/WeChatAppEx"

    # WMPF and VLC both ship libffmpeg.so, but WMPF requires its own ABI.
    patchelf --replace-needed \
      libffmpeg.so \
      "$out/opt/wechat/RadiumWMPF/runtime/libffmpeg.so" \
      "$out/opt/wechat/RadiumWMPF/runtime/WeChatAppEx"
  '';

  passthru = passthru // {
    source =
      finalAttrs.passthru.sources.${stdenvNoCC.hostPlatform.system}
        or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}");
  };

  meta = meta // {
    platforms = lib.attrNames finalAttrs.passthru.sources;
  };
})
