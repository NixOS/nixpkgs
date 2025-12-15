{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  makeWrapper,
  alsa-lib,
  bintools,
  brotli,
  cairo,
  cups,
  curl,
  dbus,
  expat,
  fontconfig,
  freetype,
  glib,
  gsm,
  gst_all_1,
  harfbuzz,
  lcms,
  libbluray,
  libcap,
  libdrm,
  libevent,
  libgbm,
  libGL,
  libGLU,
  libkrb5,
  libmng,
  libopenmpt,
  libopus,
  libpulseaudio,
  librsvg,
  libtheora,
  libtiff,
  libva,
  libvdpau,
  libwebp,
  libxkbcommon,
  libxkbfile,
  libxml2,
  libxslt,
  mtdev,
  nspr,
  nss,
  numactl,
  ocl-icd,
  openjpeg,
  openssl,
  snappy,
  speex,
  systemdLibs,
  tslib,
  twolame,
  wavpack,
  wayland,
  xorg,
  xvidcore,
  zlib,
  zstd,
  zvbi,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "viber";
  version = "24.9.0.3";

  src = fetchurl {
    # Taking Internet Archive snapshot of a specific version to avoid breakage
    # on new versions
    url = "https://web.archive.org/web/20250830135453/https://download.cdn.viber.com/cdn/desktop/Linux/viber.deb";
    hash = "sha256-i7fG8Sdl/v5QAyTsCh6OKe4BDYnQ0jBJgSdqMOrkLNo=";
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
  ];

  libPath = lib.makeLibraryPath [
    alsa-lib
    brotli
    cairo
    cups
    curl
    dbus
    expat
    fontconfig
    freetype
    glib
    gsm
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gstreamer
    harfbuzz
    lcms
    libbluray
    libcap
    libdrm
    libevent
    libgbm
    libGL
    libGLU
    libkrb5
    libmng
    libopenmpt
    libopus
    libpulseaudio
    librsvg
    libtheora
    libtiff
    libva
    libvdpau
    libwebp
    libxkbcommon
    libxkbfile
    libxml2
    libxslt
    mtdev
    nspr
    nss
    numactl
    ocl-icd
    openjpeg
    openssl
    snappy
    speex
    stdenv.cc.cc
    systemdLibs
    tslib
    twolame
    wavpack
    wayland
    xorg.libICE
    xorg.libSM
    xorg.libX11
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXScrnSaver
    xorg.libXtst
    xorg.libxcb
    xorg.xcbutilimage
    xorg.xcbutilkeysyms
    xorg.xcbutilrenderutil
    xorg.xcbutilwm
    xvidcore
    zlib
    zstd
    zvbi
  ];

  installPhase = ''
    runHook preInstall

    cp -r . $out

    for file in $(find $out -type f \( -perm /0111 -o -name \*.so\* \) ); do
      patchelf --set-interpreter ${bintools.dynamicLinker} "$file" || true
      patchelf --set-rpath ${finalAttrs.libPath}:$out/opt/viber/lib $file || true
    done

    mkdir $out/bin
    # qt.conf is not working, so override everything using environment variables
    makeWrapper $out/opt/viber/Viber $out/bin/viber \
      --set QT_QPA_PLATFORM "xcb" \
      --set QT_PLUGIN_PATH "$out/opt/viber/plugins" \
      --set QT_XKB_CONFIG_ROOT "${xorg.xkeyboardconfig}/share/X11/xkb" \
      --set QTCOMPOSE "${xorg.libX11.out}/share/X11/locale" \
      --set QML2_IMPORT_PATH "$out/opt/viber/qml"

    mv $out/usr/share $out/share
    rm -rf $out/usr
    # Fix the desktop link
    substituteInPlace $out/share/applications/viber.desktop \
      --replace-fail "/opt/viber/" "$out/opt/viber/"
    # Fix libxml2 breakage. See https://github.com/NixOS/nixpkgs/pull/396195#issuecomment-2881757108
    ln -s "${lib.getLib libxml2}/lib/libxml2.so" "$out/opt/viber/lib/libxml2.so.2"

    runHook postInstall
  '';

  dontStrip = true;
  dontPatchELF = true;

  meta = {
    homepage = "https://www.viber.com";
    description = "Instant messaging and Voice over IP (VoIP) app";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
})
