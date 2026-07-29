{
  stdenv,
  lib,
  fetchurl,
  makeWrapper,
  copyDesktopItems,
  autoPatchelfHook,

  # Upstream is built with older Electron
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
  libx11,
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
  srcs = {
    x86_64-linux = {
      url = "https://upload-cdn.zepp.com/zepp-applet-and-wechat-applet/20260410/simulator_2.1.1_linux_amd64.deb";
      hash = "sha256-+cRt2jZexe3hI+jN2Lp58uM8GBDvEDqt/u3rp5F0wPo=";
    };
    aarch64-linux = {
      url = "https://upload-cdn.zepp.com/zepp-applet-and-wechat-applet/20260509/simulator_2.1.1_arm64.deb";
      hash = "sha256-JnMfiKmA3tyMYDtO2XoeGYOLE2wANKixcfz9wesXoLk=";
    };
  };

in

stdenv.mkDerivation {
  pname = "zepp-simulator";
  version = "2.1.1";

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

  buildInputs = [
    # QEMU deps (runtime):
    glib
    libgcc
    libcxx
    zlib
    libepoxy
    libpng
    libaio
    libx11
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
