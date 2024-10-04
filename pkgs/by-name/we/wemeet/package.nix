{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeWrapper,

  nss,
  xorg,
  desktop-file-utils,
  libpulseaudio,
  libgcrypt,
  dbus,
  systemd,
  udev,
  libGL,
  fontconfig,
  freetype,
  openssl,
  wayland,
  libdrm,
  harfbuzz,
  openldap,
  curl,
  nghttp2,
  libunwind,
  alsa-lib,
  libidn2,
  rtmpdump,
  libpsl,
  libkrb5,
  xkeyboard_config,
  zenity,
}:

stdenv.mkDerivation {
  pname = "wemeet";
  version = "3.19.2.400";

  src = fetchurl {
    # Source deb pack comes from the official link:
    # https://meeting.tencent.com/download/
    url = "https://updatecdn.meeting.qq.com/cos/fb7464ffb18b94a06868265bed984007/TencentMeeting_0300000000_3.19.2.400_x86_64_default.publish.officialwebsite.deb";
    hash = "sha256-PSGc4urZnoBxtk1cwwz/oeXMwnI02Mv1pN2e9eEf5kE=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    nss
    xorg.libX11
    desktop-file-utils
    libpulseaudio
    libgcrypt
    dbus
    systemd
    udev
    libGL
    xorg.libSM
    xorg.libICE
    xorg.libXtst
    libGL
    fontconfig
    freetype
    openssl
    wayland
    libdrm
    harfbuzz
    openldap
    curl
    nghttp2
    libunwind
    alsa-lib
    libidn2
    rtmpdump
    libpsl
    libkrb5
    xkeyboard_config
  ];

  unpackPhase = ''
    runHook preUnpack
    dpkg -x $src .
    runHook postUnpack
  '';

  # Solving wayland problem
  # https://build.openkylin.top/openkylin/+source/openkylin-default-settings/1:2.0.3
  installPhase = ''
    runHook preInstall

    prefix=$out/opt/wemeet

    mkdir -p $out
    cp -r opt $out
    cp -r usr/* $out
    rm $out/opt/wemeet/lib/libcurl.so

    substituteInPlace $prefix/wemeetapp.sh \
      --replace-fail "检测到窗口系统采用wayland协议，腾讯会议暂不兼容，程序即将退出！" \
                "检测到窗口系统采用 Wayland 协议，将尝试在 XWayland 模式下启动。" \
      --replace-fail "exit 1" "export XDG_SESSION_TYPE=x11; unset WAYLAND_DISPLAY" \
      --replace-fail zenity ${zenity}/bin/zenity

    substituteInPlace $out/share/applications/wemeetapp.desktop \
      --replace-fail /opt/wemeet $prefix

    wrapProgram $prefix/wemeetapp.sh \
      --set XKB_CONFIG_ROOT "${xkeyboard_config}/share/X11/xkb"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Wemeet - Tencent Video Conferencing";
    homepage = "https://wemeet.qq.com";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ zincentimeter ];
    mainProgram = "wemeetapp";
  };
}
