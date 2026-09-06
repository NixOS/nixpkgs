{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  dpkg,
  makeShellWrapper,
  wrapGAppsHook3,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  cairo,
  cups,
  dbus,
  expat,
  gdk-pixbuf,
  glib,
  gtk3,
  libGL,
  libdrm,
  libgbm,
  libx11,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxrandr,
  libxkbcommon,
  libxshmfence,
  mesa,
  nspr,
  nss,
  pango,
  systemd,
}:

let
  sources = {
    x86_64-linux = fetchurl {
      url = "https://cdn-zcode.z.ai/zcode/electron/releases/3.11.2/linux-x64/ZCode-3.11.2-linux-x64.deb";
      hash = "sha256-fRO4OGMTAs9h4bgEDLZ/NJ7CNWZ5WJfxdGQyxcXXfVs=";
    };
    aarch64-linux = fetchurl {
      url = "https://cdn-zcode.z.ai/zcode/electron/releases/3.11.2/linux-arm64/ZCode-3.11.2-linux-arm64.deb";
      hash = "sha256-3jFIe5eq3hNlvb8cOhYkM2zRY9uJlkFqT4lG9JHu7bA=";
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "zcode";
  version = "3.11.2";

  src =
    sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  dontConfigure = true;
  dontBuild = true;
  dontUnpack = true;

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeShellWrapper
    wrapGAppsHook3
  ];

  buildInputs = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    gdk-pixbuf
    glib
    gtk3
    libGL
    libdrm
    libgbm
    libx11
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxrandr
    libxkbcommon
    libxshmfence
    mesa
    nspr
    nss
    pango
    systemd
  ];

  # deb 内 chrome-sandbox 是 setuid 二进制，dpkg -x 会因权限失败，
  # 对齐 feishu 包：--fsys-tarfile 走 tar 解（对齐 nixpkgs feishu 包）
  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/ZCode $out/bin
    dpkg --fsys-tarfile $src | tar --extract -C .
    cp -r opt/ZCode/. $out/opt/ZCode/

    # 主二进制：Wayland/X11 自适应 + 关闭 setuid sandbox（NixOS 无 SUID 环境）
    makeShellWrapper $out/opt/ZCode/zcode $out/bin/zcode \
      "''${gappsWrapperArgs[@]}" \
      --add-flags "--ozone-platform-hint=auto" \
      --add-flags "--no-sandbox"

    # 桌面入口 + 图标
    mkdir -p $out/share/applications $out/share/icons/hicolor
    cp usr/share/applications/zcode.desktop $out/share/applications/
    substituteInPlace $out/share/applications/zcode.desktop \
      --replace-fail /opt/ZCode/zcode zcode
    cp -r usr/share/icons/hicolor/. $out/share/icons/hicolor/

    runHook postInstall
  '';

  meta = {
    description = "Z.AI ZCode, official harness for GLM coding";
    homepage = "https://zcode.z.ai";
    downloadPage = "https://zcode.z.ai/en#all-downloads";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ asgpipo ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "zcode";
  };
})
