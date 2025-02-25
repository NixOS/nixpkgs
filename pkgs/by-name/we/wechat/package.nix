{
  lib,
  stdenv,
  fetchurl,
  undmg,
  dpkg,
  autoPatchelfHook,
  makeBinaryWrapper,

  glib,
  bzip2,
  zlib,
  libxkbcommon,
  fontconfig,
  dbus,
  nss,
  nspr,
  libGL,
  atkmm,
  at-spi2-atk,
  mesa,
  libdrm,
  pango,
  cairo,
  alsa-lib,
  libpulseaudio,
  libjack2,
  xorg,
}:
let
  srcs = {
    x86_64-linux = fetchurl {
      url = "https://web.archive.org/web/20241107205050/https://dldir1v6.qq.com/weixin/Universal/Linux/WeChatLinux_x86_64.deb";
      hash = "sha256-Dig0MQ4dMh2oQaTN6cZX2cCGxe6MgtCeR+q1NimlA48=";
    };
    aarch64-linux = fetchurl {
      url = "https://web.archive.org/web/20241107205052/https://dldir1v6.qq.com/weixin/Universal/Linux/WeChatLinux_arm64.deb";
      hash = "sha256-3R9QKbsgJ03XkDoMW/d5bhOSJi4EjOiCZVMKiDKNcuw=";
    };
    loongarch64-linux = fetchurl {
      url = "https://web.archive.org/web/20241106060406/https://dldir1v6.qq.com/weixin/Universal/Linux/WeChatLinux_LoongArch.deb";
      hash = "sha256-UBdUOw/orSi/hi3uySxKf676e5W7ogXyAQehXGpaIJg=";
    };
    x86_64-darwin = fetchurl {
      url = "https://web.archive.org/web/20241107193311/https://dldir1v6.qq.com/weixin/Universal/Mac/WeChatMac_x86_64.dmg";
      hash = "sha256-IMG3By5CnZOwxjOyIUG79XZ8g1HrYY2GkuvUd4Ekpqs=";
    };
    aarch64-darwin = fetchurl {
      url = "http://web.archive.org/web/20241107194014/https://dldir1v6.qq.com/weixin/Universal/Mac/WeChatMac_arm64.dmg";
      hash = "sha256-1ocgPaOOn+FntBCuVcKsFJanhCKgQH3lqRuGsfOvp2c=";
    };
  };

  # zerocallusedregs hardening breaks WeChat
  glibcWithoutHardening = stdenv.cc.libc.overrideAttrs (old: {
    hardeningDisable = (old.hardeningDisable or [ ]) ++ [ "zerocallusedregs" ];
  });
in
stdenv.mkDerivation {
  pname = "wechat";
  version = if stdenv.hostPlatform.isDarwin then "4.0.0.5" else "4.0.0.30";

  src = srcs.${stdenv.hostPlatform.system};

  nativeBuildInputs =
    if stdenv.hostPlatform.isDarwin then
      [ undmg ]
    else
      [
        dpkg
        autoPatchelfHook
        makeBinaryWrapper
      ];

  buildInputs = lib.optional stdenv.hostPlatform.isLinux [
    glib
    bzip2
    zlib
    libxkbcommon
    fontconfig
    dbus
    nss
    nspr
    libGL
    atkmm
    at-spi2-atk
    mesa
    libdrm
    pango.dev
    cairo
    alsa-lib
    libpulseaudio
    libjack2

    xorg.libX11
    xorg.libXrandr
    xorg.libXrender
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libxcb
    xorg.xcbutilimage
    xorg.xcbutilwm
    xorg.xcbutilrenderutil
    xorg.xcbutilkeysyms
  ];

  unpackCmd = lib.optionalString stdenv.hostPlatform.isLinux "dpkg-deb -x $src debcontents";

  installPhase =
    ''
      runHook preInstall
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p $out/Applications
      cp -r *.app $out/Applications
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      install -Dm644 opt/wechat/*.so* -t $out/lib
      cp -r opt/wechat/{ocr_model,RadiumWMPF,vlc_plugins,XEditor,XFile} -t $out/lib
      install -Dm755 opt/wechat/{wechat,wxocr,wxplayer,crashpad_handler} -t $out/bin
      cp -r usr/share -t $out
    ''
    + ''
      runHook postInstall
    '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    wrapProgram $out/bin/wechat \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ glibcWithoutHardening ]}

    substituteInPlace $out/share/applications/wechat.desktop \
      --replace-fail "Name=wechat" "Name=WeChat" \
      --replace-fail "/usr/bin/wechat" "wechat" \
      --replace-fail "/usr/share/icons/hicolor/256x256/apps/wechat.png" "wechat"
  '';

  meta = {
    description = "Instant messaging, social media and mobile payment app by Tencent";
    homepage = "https://wechat.com";
    license = with lib.licenses; [ unfree ];
    platforms = lib.attrNames srcs;
    maintainers = with lib.maintainers; [ pluiedev ];
    mainProgram = "wechat";
  };
}
