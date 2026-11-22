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
  libsecret,
  libxcb,
  libxcb-keysyms,
  libxkbcommon,
  mesa,
  nspr,
  nss,
  pango,
  pciutils,
  pipewire,
  systemd,
  util-linuxMinimal,
  wayland,
  which,
  xdg-utils,
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

  # Try upstream first as Wayback Machine is slow in China (where most users are located)
  src = fetchurl {
    inherit (finalAttrs.passthru.source.src) url hash;
    netrcPhase = ''
      touch netrc

      url=${lib.escapeShellArg finalAttrs.passthru.source.upstream.url}
      crc=${lib.escapeShellArg (finalAttrs.passthru.source.upstream."x-cos-hash-crc64ecma" or "")}
      ver=${lib.escapeShellArg (finalAttrs.passthru.source.upstream."x-cos-version-id" or "")}

      if [[ -n "$crc" && -n "$ver" ]] && actual=$(curl -fsSIL -o /dev/null -w '%header{x-cos-hash-crc64ecma}:%header{x-cos-version-id}' "$url") && [[ "$actual" == "$crc:$ver" ]]; then
        urls=("$url")
      fi
    '';
  };

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
    libsecret
    libxcursor
    pciutils
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
      --replace-fail "/usr/bin/wechat" "wechat"

    substituteInPlace "$out/share/applications/com.tencent.wechatappex.desktop" \
      --replace-fail "/opt/wechat/RadiumWMPF/runtime/WeChatAppEx" "$out/opt/wechat/RadiumWMPF/runtime/WeChatAppEx"

    sed -i 's|^Icon=.*|Icon=wechat|' "$out/share/applications/wechat.desktop"

    runHook postInstall
  '';

  dontWrapGApps = true;

  preFixup = ''
    mkdir -p "$out/bin"

    makeShellWrapper "$out/opt/wechat/wechat" "$out/bin/wechat" \
      "''${gappsWrapperArgs[@]}" \
      --suffix PATH : "${
        lib.makeBinPath [
          dbus
          glib
          which
          xdg-utils
        ]
      }" \
      --prefix LD_PRELOAD : "${lib.getLib libredirect}/lib/libredirect.so" \
      --prefix NIX_REDIRECTS : "/usr/bin/lsblk=${lib.getExe' util-linuxMinimal "lsblk"}" \
      --set XKB_CONFIG_ROOT "${xkeyboard-config}/share/X11/xkb" \
      --set XLOCALEDIR "${libx11}/share/X11/locale" \
      --set-default QT_AUTO_SCREEN_SCALE_FACTOR 1 \
      --run '
        if [ -z "''${QT_QPA_PLATFORM:-}" ]; then
          if [ -n "''${WAYLAND_DISPLAY:-}" ] || [ "''${XDG_SESSION_TYPE:-}" = wayland ]; then
            export QT_QPA_PLATFORM=wayland
            export QT_IM_MODULE=text-input-unstable-v3
          else
            export QT_QPA_PLATFORM=xcb

            case "''${XMODIFIERS:-}" in
              *@im=fcitx*)
                export QT_IM_MODULE=fcitx
                export GTK_IM_MODULE=fcitx
                ;;
              *@im=ibus*)
                export QT_IM_MODULE=ibus
                export GTK_IM_MODULE=ibus
                export IBUS_USE_PORTAL=1
                ;;
            esac
          fi
        fi
      '
  '';

  postFixup = ''
    # ANGLE loads libGL.so.1 and libEGL.so.1 dynamically from the GPU process.
    patchelf --add-needed "${libglvnd}/lib/libGL.so.1" \
      --add-needed "${libglvnd}/lib/libEGL.so.1" \
      "$out/opt/wechat/RadiumWMPF/runtime/WeChatAppEx"

    # WMPF and VLC both ship libffmpeg.so, but WMPF requires its own ABI.
    patchelf --replace-needed \
      libffmpeg.so \
      "$out/opt/wechat/RadiumWMPF/runtime/libffmpeg.so" \
      "$out/opt/wechat/RadiumWMPF/runtime/WeChatAppEx"
  '';

  passthru = passthru finalAttrs;

  meta = meta finalAttrs;
})
