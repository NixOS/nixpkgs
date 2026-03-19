{
  stdenv,
  fetchurl,
  cmake,
  python3,
  perl,
  ruby,
  glib,
  harfbuzzFull,
  libjpeg,
  libepoxy,
  libgcrypt,
  libgpg-error,
  libtasn1,
  libxkbcommon,
  pkg-config,
  libxml2,
  libpng,
  sqlite,
  unifdef,
  libwebp,
  libwpe,
  gobject-introspection,
  gi-docgen,
  libsoup_3,
  atk,
  flite,
  libjxl,
  woff2,
  libxslt,
  libavif,
  systemdLibs,
  libcap,
  lcms,
  libdrm,
  libgbm,
  libbacktrace,
  libseccomp,
  bubblewrap,
  xdg-dbus-proxy,
  gst_all_1,
  gperf,
  freetype,
  fontconfig,
  libsysprof-capture,
  lib,
  expat,
  hyphen,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "wpewebkit";
  version = "2.50.6";

  src = fetchurl {
    url = "https://wpewebkit.org/releases/wpewebkit-${finalAttrs.version}.tar.xz";
    hash = "sha256-iGT9P2EWNw11Ql+bHvpI6xiMz0LJKunoqvLdUfnyfe8=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    python3
    perl
    ruby
    glib
    harfbuzzFull
    libjpeg
    libepoxy
    libgcrypt
    libgpg-error
    libtasn1
    libxkbcommon
    libxml2
    libpng
    sqlite
    unifdef
    libwebp
    libwpe
    gobject-introspection
    gi-docgen
    libsoup_3
    atk
    flite
    libjxl
    woff2
    libxslt
    libavif
    systemdLibs
    libcap
    lcms
    libdrm
    libgbm
    libseccomp
    bubblewrap
    xdg-dbus-proxy
    gst_all_1.gst-plugins-base
    gperf
    freetype
    fontconfig
    libsysprof-capture
    expat
    hyphen
  ];

  cmakeFlags = [
    "-DPORT=WPE"
    "-DUSE_LIBBACKTRACE=OFF"
  ];

  meta = {
    description = "Web engine for Linux embedded devices with hardware acceleration";
    longDescription = ''
      An Open Source Web engine for Linux-based embedded devices designed with flexibility and hardware acceleration in mind,
      leveraging common 3D graphics APIs for best performance.
    '';

    homepage = "https://wpewebkit.org";
    license = with lib.licenses; [
      bsd2
    ];

    mainProgram = "namida";
    maintainers = with lib.maintainers; [
      iwisp360
    ];

    platforms = lib.platforms.linux;
  };
})
