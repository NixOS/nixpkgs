{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  wrapGAppsHook3,
  alsa-lib,
  atk,
  cairo,
  dbus,
  ffmpeg_6,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  gtk3,
  gst_all_1,
  libglvnd,
  libpciaccess,
  libx11,
  libxcb,
  libxcomposite,
  libxcursor,
  libxdamage,
  libxext,
  libxfixes,
  libxi,
  libxrandr,
  libxrender,
  nspr,
  nss,
  pango,
  pciutils,
}:

stdenv.mkDerivation rec {
  pname = "waterfox";
  version = "6.6.12";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://cdn.waterfox.com/waterfox/releases/${version}/Linux_x86_64/waterfox-${version}.tar.bz2";
    hash = "sha256-4mEVeqGiNzO5au4LsOMc5i6UaQ/AxV9XH1ea7HAd+kU=";
  };

  nativeBuildInputs = [
    makeWrapper
    wrapGAppsHook3
  ];

  buildInputs = [
    alsa-lib
    atk
    cairo
    dbus
    ffmpeg_6
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk3
    gst_all_1.gstreamer
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-ugly
    libglvnd
    libpciaccess
    libx11
    libxcb
    libxcomposite
    libxcursor
    libxdamage
    libxext
    libxfixes
    libxi
    libxrandr
    libxrender
    nspr
    nss
    pango
    pciutils
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/waterfox
    cp -r ./* $out/lib/waterfox

    chmod +x $out/lib/waterfox/waterfox

    mkdir -p $out/bin

    makeWrapper $out/lib/waterfox/waterfox $out/bin/waterfox \
      --prefix LD_LIBRARY_PATH : "$out/lib/waterfox:${lib.makeLibraryPath buildInputs}" \
      --set MOZ_SYSTEM_FFMPEG "1"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Privacy-focused browser based on Firefox";
    homepage = "https://www.waterfox.net/";
    license = licenses.mpl20;
    platforms = platforms.linux;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    mainProgram = "waterfox";
  };
}
