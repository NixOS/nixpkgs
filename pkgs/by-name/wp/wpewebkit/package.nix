{
  at-spi2-core,
  bison,
  bubblewrap,
  cairo,
  cctools,
  cmake,
  fetchurl,
  flex,
  fontconfig,
  freetype,
  gettext,
  gi-docgen,
  glib,
  gobject-introspection,
  gperf,
  gst_all_1,
  harfbuzz,
  icu,
  lcms2,
  lib,
  libavif,
  libdrm,
  libedit,
  libepoxy,
  libgbm,
  libgcrypt,
  libgpg-error,
  libjpeg,
  libjxl,
  libpng,
  libseccomp,
  libsoup_3,
  libsysprof-capture,
  libtasn1,
  libwebp,
  libwpe,
  libwpe-fdo,
  libxkbcommon,
  libxml2,
  libxslt,
  mesa,
  ninja,
  p11-kit,
  perl,
  pkg-config,
  python3,
  ruby,
  sqlite,
  stdenv,
  systemd,
  unifdef,
  wayland,
  wayland-protocols,
  wayland-scanner,
  woff2,
  xdg-dbus-proxy,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wpewebkit";
  version = "2.50.0";

  src = fetchurl {
    url = "https://wpewebkit.org/releases/wpewebkit-${finalAttrs.version}.tar.xz";
    hash = "sha256-qa9ixeGFUbc4a324ZOi6gVbyGbjmxjmTS/bzpWeWmSI=";
  };

  nativeBuildInputs = [
    bison
    cmake
    flex
    gettext
    gi-docgen
    gobject-introspection
    gperf
    libsysprof-capture
    ninja
    perl
    pkg-config
    python3
    ruby
    unifdef
    wayland-protocols
    wayland-scanner
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    cctools
  ];

  buildInputs = [
    at-spi2-core
    bubblewrap
    cairo
    fontconfig
    freetype
    glib
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gstreamer
    icu
    (harfbuzz.override { withIcu = true; })
    lcms2
    libavif
    libdrm
    libedit
    libepoxy
    libgbm
    libgcrypt
    libgpg-error
    libjpeg
    libjxl
    libpng
    libseccomp
    libsoup_3
    libtasn1
    libwebp
    libwpe
    libwpe-fdo
    libxkbcommon
    libxml2
    libxslt
    mesa
    p11-kit
    sqlite
    systemd
    wayland
    woff2
    xdg-dbus-proxy
    zlib
  ];

  cmakeFlags = [
    (lib.cmakeFeature "PORT" "WPE")
    (lib.cmakeBool "ENABLE_DOCUMENTATION" true)
    (lib.cmakeBool "ENABLE_INTROSPECTION" true)
    (lib.cmakeBool "ENABLE_MINIBROWSER" true)
    (lib.cmakeBool "ENABLE_SPEECH_SYNTHESIS" false)
    (lib.cmakeBool "USE_LIBBACKTRACE" false)
  ];

  meta = {
    description = "WPE WebKit port optimized for embedded devices";
    homepage = "https://wpewebkit.org";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ eval-exec ];
    platforms = with lib.platforms; linux ++ darwin;
  };
})
