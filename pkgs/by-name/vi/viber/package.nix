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
  libxshmfence,
  libxcb-cursor,
  libxcb-util,
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
  xkeyboard-config,
  libxcb-wm,
  libxcb-render-util,
  libxcb-keysyms,
  libxcb-image,
  libxtst,
  libxscrnsaver,
  libxrender,
  libxrandr,
  libxi,
  libxfixes,
  libxext,
  libxdamage,
  libxcursor,
  libxcomposite,
  libx11,
  libsm,
  libice,
  libxcb,
  xvidcore,
  zlib,
  zstd,
  zvbi,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "viber";
  version = "27.3.0.2";

  src = fetchurl {
    # Taking Internet Archive snapshot of a specific version to avoid breakage
    # on new versions
    url = "https://web.archive.org/web/20260518041738/https://download.cdn.viber.com/cdn/desktop/Linux/viber.deb";
    hash = "sha256-lhU03Ay5IABux66BCLDhugmkdu7x4TtLNwp5zVLdIPM=";
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
  ];

  buildInputs = [
    libxml2.dev
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
    libxshmfence
    libxcb-cursor
    libxcb-util
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
    libice
    libsm
    libx11
    libxcomposite
    libxcursor
    libxdamage
    libxext
    libxfixes
    libxi
    libxrandr
    libxrender
    libxscrnsaver
    libxtst
    libxcb
    libxcb-image
    libxcb-keysyms
    libxcb-render-util
    libxcb-wm
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

        # Build a shim that re-exports valuePush/valuePop with the old LIBXML2_2.4.30
        # version tag. Qt6WebEngine in Viber was compiled against libxml2 < 2.13 where
        # these were public API; 2.13+ renamed them to xmlXPathValuePush/Pop and dropped
        # the old versioned exports.
        cat > libxml2-compat.c << 'EOF'
    #include <libxml/xpathInternals.h>
    #undef valuePush
    #undef valuePop
    int valuePush(xmlXPathParserContextPtr ctxt, xmlXPathObjectPtr value) {
        return xmlXPathValuePush(ctxt, value);
    }
    xmlXPathObjectPtr valuePop(xmlXPathParserContextPtr ctxt) {
        return xmlXPathValuePop(ctxt);
    }
    EOF
        cat > libxml2-compat.map << 'EOF'
    LIBXML2_2.4.30 {
      global: valuePush; valuePop;
      local: *;
    };
    EOF
        $CC -shared -fPIC -o $out/opt/viber/lib/libxml2-compat.so libxml2-compat.c \
          -I${libxml2.dev}/include/libxml2 \
          -L${lib.getLib libxml2}/lib -lxml2 \
          -Wl,--version-script=libxml2-compat.map

        mkdir $out/bin
        # qt.conf is not working, so override everything using environment variables
        makeWrapper $out/opt/viber/Viber $out/bin/viber \
          --set QT_QPA_PLATFORM "xcb" \
          --set QT_PLUGIN_PATH "$out/opt/viber/plugins" \
          --set QT_XKB_CONFIG_ROOT "${xkeyboard-config}/share/X11/xkb" \
          --set QTCOMPOSE "${libx11.out}/share/X11/locale" \
          --set QML2_IMPORT_PATH "$out/opt/viber/qml" \
          --prefix LD_PRELOAD : "$out/opt/viber/lib/libxml2-compat.so"

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
