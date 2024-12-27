{
  stdenv,
  lib,
  fetchurl,
  makeWrapper,
  copyDesktopItems,
  autoPatchelfHook,

  # Upstream is officialy built with Electron 18
  # (but it works with latest Electron with minor changes, see HACK below)
  electron,
  asar,
  dpkg,

  # qemu deps
  # (it's not possible to de-vendor the qemu binary since it relies on proprietary cpu extensions)
  glib,
  libgcc,
  libcxx,
  zlib,
  libepoxy,
  libpng,
  libaio,
  xorg,
  libvterm,
  vte,
  gsasl,
  gtk3,
  cairo,
  gdk-pixbuf,
  numactl,
  cyrus_sasl,
  SDL2,
  # aarch64-only?
  dtc,
  capstone_4,
  libjpeg8,
  libgbm,
  curlWithGnuTls,
}:

let
  # CDN links for 2.0.2:
  # MacOS: https://upload-cdn.zepp.com/zepp-applet-and-wechat-applet/20240927/ecb6ca54f4dc97a2f91e53358bbb532d.dmg
  # Windows: https://upload-cdn.zepp.com/zepp-applet-and-wechat-applet/20240927/9db7ae1c60c26836a447a71a6fb25b3b.exe
  # Linux ARM64: https://upload-cdn.zepp.com/zepp-applet-and-wechat-applet/20240927/02ec69e6a2f3b744d964fd7ba4f40fc3.deb
  # Linux AMD64: https://upload-cdn.zepp.com/zepp-applet-and-wechat-applet/20240927/3e688d423cd0cd31a8a589b8325a309e.deb
  srcs = {
    x86_64-linux = {
      url = "https://upload-cdn.zepp.com/zepp-applet-and-wechat-applet/20240927/3e688d423cd0cd31a8a589b8325a309e.deb";
      sha256 = "sha256-ZHqaEL8FoSnRtuqGWpTyJka7D0dHtRADZthq8DG2k24=";
    };
    aarch64-linux = {
      url = "https://upload-cdn.zepp.com/zepp-applet-and-wechat-applet/20240927/02ec69e6a2f3b744d964fd7ba4f40fc3.deb";
      sha256 = "sha256-J5Y4wLiFOM9D2MIMiRyUtHIZ19rt65ktVCOMZQQwBCI=";
    };
  };

in

stdenv.mkDerivation {
  pname = "zepp-simulator";
  version = "2.0.2";

  src = fetchurl srcs.${stdenv.hostPlatform.system};

  patches = [
    # Fix for qemu input grab not working with NIXOS_OZONE_WL=1
    ./0001-force_qemu_x11.patch
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    makeWrapper
    dpkg
    asar
  ];

  buildInputs =
    [
      # QEMU deps (runtime):
      glib
      libgcc
      libcxx
      zlib
      libepoxy
      libpng
      libaio
      xorg.libX11
      libvterm
      vte
      gsasl
      numactl
      cyrus_sasl
      gtk3
      cairo
      gdk-pixbuf
      SDL2
    ]
    ++ lib.optionals (stdenv.hostPlatform.system == "aarch64-linux") [
      libjpeg8
      dtc
      capstone_4
      libgbm
      curlWithGnuTls
    ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    # Create output file strucure
    mkdir -p $out/{bin,opt,share}
    cp -r opt/simulator $out/opt
    cp -r usr/share/* $out/share

    # Patch desktop file executable path
    substituteInPlace $out/share/applications/simulator.desktop \
      --replace-fail '/opt/simulator/simulator' 'simulator'

    # Remove unnecessary files
    rm -rf \
      $out/usr/share/applications/simulator.desktop \
      $out/opt/simulator/*.so \
      $out/opt/simulator/libvulkan.so.1 \
      $out/opt/simulator/swiftshader \
      $out/opt/simulator/simulator \
      $out/opt/simulator/resources/firmware/setup_for_linux.sh

    # Use system electron
    makeWrapper ${lib.getExe electron} $out/bin/simulator \
      --add-flags "--no-sandbox" \
      --add-flags $out/opt/simulator/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
      --set-default NODE_ENV production \
      --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
      --set-default ELECTRON_IS_DEV 0 \
      --set-default ELECTRON_DISABLE_SECURITY_WARNINGS 1 \
      --inherit-argv0;

    # HACK: disable sandbox introduced in Electron 20
    asar extract $out/opt/simulator/resources/app.asar app_unpacked
    rm $out/opt/simulator/resources/app.asar
    sed -i \
      's|contextIsolation: false,|contextIsolation: false, sandbox: false,|g' \
      app_unpacked/build/electron/process/side-service.js
    asar pack app_unpacked $out/opt/simulator/resources/app.asar
    rm -rf app_unpacked

    runHook postInstall
  '';

  # HACK: Replace libsasl2.so.ls with libsasl2.so.3
  postFixup = ''
    patchelf \
      --replace-needed libsasl2.so.2 libsasl2.so.3 \
      $out/opt/simulator/resources/firmware/qemu_linux/qemu-system-arm
    chmod +x $out/opt/simulator/resources/firmware/qemu_linux/qemu-system-arm
  '';

  meta = {
    description = "Zepp OS Simulator";
    homepage = "https://developer.zepp.com/os/home";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    # TODO Darwin
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = with lib.maintainers; [ griffi-gh ];
    mainProgram = "simulator";
  };
}
