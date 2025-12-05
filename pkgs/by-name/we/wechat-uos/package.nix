{
  stdenvNoCC,
  stdenv,
  lib,
  fetchurl,
  dpkg,
  nss,
  nspr,
  xorg,
  pango,
  zlib,
  atkmm,
  libdrm,
  libxkbcommon,
  xcbutilwm,
  xcbutilimage,
  xcbutilkeysyms,
  xcbutilrenderutil,
  libgbm,
  alsa-lib,
  wayland,
  atk,
  qt6,
  at-spi2-atk,
  at-spi2-core,
  dbus,
  cups,
  gtk3,
  libxml2,
  cairo,
  freetype,
  fontconfig,
  vulkan-loader,
  gdk-pixbuf,
  libexif,
  ffmpeg,
  pulseaudio,
  systemd,
  libuuid,
  expat,
  bzip2,
  glib,
  libva,
  libGL,
  libnotify,
  krb5,
  buildFHSEnv,
  writeShellScript,
}:
let
  wechat-uos-env = stdenvNoCC.mkDerivation {
    meta.priority = 1;
    name = "wechat-uos-env";
    buildCommand = ''
      mkdir -p $out/etc
      mkdir -p $out/usr/bin
      mkdir -p $out/usr/share
      mkdir -p $out/opt
      mkdir -p $out/var

      ln -s ${wechat}/opt/* $out/opt/
    '';

  };

  wechat-uos-runtime = with xorg; [
    stdenv.cc.cc
    stdenv.cc.libc
    pango
    zlib
    xcbutilwm
    xcbutilimage
    xcbutilkeysyms
    xcbutilrenderutil
    libX11
    libXt
    libXext
    libSM
    libICE
    libxcb
    libxkbcommon
    libxshmfence
    libXi
    libXft
    libXcursor
    libXfixes
    libXScrnSaver
    libXcomposite
    libXdamage
    libXtst
    libXrandr
    libnotify
    atk
    atkmm
    cairo
    at-spi2-atk
    at-spi2-core
    alsa-lib
    dbus
    cups
    gtk3
    gdk-pixbuf
    libexif
    ffmpeg
    libva
    freetype
    fontconfig
    libXrender
    libuuid
    expat
    glib
    nss
    nspr
    libGL
    libxml2
    pango
    libdrm
    libgbm
    vulkan-loader
    systemd
    wayland
    pulseaudio
    qt6.qt5compat
    bzip2
    krb5
  ];

  wechat =
    let
      sources = import ./sources.nix;

      pname = "wechat-uos";
      version = sources.version;
      src = fetchurl (
        {
          curlOpts = "-A apt";
        }
        // (sources.${stdenv.hostPlatform.system}
          or (throw "Unsupported system: ${stdenv.hostPlatform.system}")
        )
      );
    in
    stdenvNoCC.mkDerivation {
      inherit pname src version;

      nativeBuildInputs = [ dpkg ];

      unpackPhase = ''
        runHook preUnpack

        dpkg -x $src ./wechat-uos

        runHook postUnpack
      '';

      # Use ln for license to prevent being garbage collection
      installPhase = ''
        runHook preInstall
        mkdir -p $out

        cp -r wechat-uos/* $out

        runHook postInstall
      '';

      meta = with lib; {
        description = "Messaging app";
        homepage = "https://weixin.qq.com/";
        license = licenses.unfree;
        platforms = [
          "x86_64-linux"
          "aarch64-linux"
          "loongarch64-linux"
        ];
        sourceProvenance = with sourceTypes; [ binaryNativeCode ];
        maintainers = with maintainers; [
          pokon548
          xddxdd
        ];
        mainProgram = "wechat-uos";
      };
    };
in
buildFHSEnv {
  inherit (wechat) pname version meta;
  runScript = writeShellScript "wechat-uos-launcher" ''
    export QT_QPA_PLATFORM=xcb
    export QT_AUTO_SCREEN_SCALE_FACTOR=1
    export LD_LIBRARY_PATH=${lib.makeLibraryPath wechat-uos-runtime}

    if [[ ''${XMODIFIERS} =~ fcitx ]]; then
      export QT_IM_MODULE=fcitx
      export GTK_IM_MODULE=fcitx
    elif [[ ''${XMODIFIERS} =~ ibus ]]; then
      export QT_IM_MODULE=ibus
      export GTK_IM_MODULE=ibus
      export IBUS_USE_PORTAL=1
    fi

    ${wechat.outPath}/opt/apps/com.tencent.wechat/files/wechat
  '';
  extraInstallCommands = ''
    mkdir -p $out/share/applications
    mkdir -p $out/share/icons
    cp -r ${wechat.outPath}/opt/apps/com.tencent.wechat/entries/applications/com.tencent.wechat.desktop $out/share/applications
    cp -r ${wechat.outPath}/opt/apps/com.tencent.wechat/entries/icons/* $out/share/icons/

    substituteInPlace $out/share/applications/com.tencent.wechat.desktop \
      --replace-quiet 'Exec=/usr/bin/wechat' "Exec=$out/bin/wechat-uos --"

    # See https://github.com/NixOS/nixpkgs/issues/413491
    sed -i \
      -e '/\[Desktop Entry\]/a\' \
      -e 'StartupWMClass=wechat' \
      $out/share/applications/com.tencent.wechat.desktop
  '';
  targetPkgs = pkgs: [ wechat-uos-env ];

  passthru.updateScript = ./update.sh;

  extraOutputsToInstall = [
    "usr"
    "var/lib/uos"
    "var/uos"
    "etc"
  ];
}
