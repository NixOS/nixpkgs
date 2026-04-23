{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  glib,
  at-spi2-atk,
  cairo,
  pango,
  gtk3,
  nss,
  nspr,
  cups,
  dbus,
  libdrm,
  libxkbcommon,
  alsa-lib,
  expat,
  libxrandr,
  libxfixes,
  libxext,
  libxdamage,
  libxcomposite,
  libx11,
  libxkbfile,
  libxcb,
  libgbm,
  systemd,
  libGL,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xmind";
  version = "26.01.03145-202510170359";

  src = fetchurl {
    url = "https://dl3.xmind.app/Xmind-for-Linux-amd64bit-${finalAttrs.version}.deb";
    hash = "sha256-h7qxDf219+t8oAk8IABs7MyasNd3K/PAM6a79kyaLdw=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
  ];

  buildInputs = [
    (lib.getLib stdenv.cc.cc)
    libx11
    libxext
    libxcb
    libxcomposite
    libxdamage
    libxfixes
    libxrandr
    libxkbfile
    glib
    at-spi2-atk
    cairo
    pango
    gtk3
    nss
    nspr
    cups
    dbus
    libdrm
    libxkbcommon
    alsa-lib
    expat
    libgbm
  ];

  runtimeDependencies = map lib.getLib [
    systemd
  ];

  installPhase = ''
    runHook preInstall

    substituteInPlace usr/share/applications/xmind.desktop \
      --replace-fail "/opt/Xmind/xmind" "xmind"
    cp -r usr $out
    mkdir -p $out/opt $out/bin
    cp -r opt/Xmind $out/opt/xmind
    ln -s $out/opt/xmind/xmind $out/bin/xmind

    runHook postInstall
  '';

  preFixup = ''
    patchelf --add-needed libGL.so.1 \
      --add-rpath ${
        lib.makeLibraryPath [
          libGL
        ]
      } $out/opt/xmind/xmind
  '';

  meta = {
    description = "All-in-one thinking tool featuring mind mapping, AI generation, and real-time collaboration";
    homepage = "https://xmind.app";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "xmind";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ michalrus ];
  };
})
