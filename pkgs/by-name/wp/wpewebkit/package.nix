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
  testers,
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
  version = "2.50.4";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  outputBin = "dev";

  src = fetchurl {
    url = "https://wpewebkit.org/releases/wpewebkit-${finalAttrs.version}.tar.xz";
    hash = "sha256-0gTkBbCXVQh0jAJzwYCQMEqXnhFw/6KgpSj62QGR74c=";
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

  postFixup = ''
    moveToOutput "share/doc" "$devdoc"
  '';

  passthru.tests = {
    pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
    };

    simple-compilation = stdenv.mkDerivation {
      name = "wpewebkit-test-simple-compilation";

      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        finalAttrs.finalPackage
        glib
        libwpe
        libsoup_3
      ];

      dontUnpack = true;

      buildPhase = ''
        cat > test.c <<EOF
        #include <wpe/webkit.h>
        #include <stdio.h>

        int main(void) {
            printf("WPE WebKit version: %d.%d.%d\n",
                   webkit_get_major_version(),
                   webkit_get_minor_version(),
                   webkit_get_micro_version());
            return 0;
        }
        EOF

        $CC test.c -o test $(pkg-config --cflags --libs wpe-webkit-2.0)
      '';

      installPhase = ''
        mkdir -p $out/bin
        install -m755 test $out/bin/wpewebkit-test
      '';
    };
  };

  meta = {
    description = "WPE WebKit port optimized for embedded devices";
    homepage = "https://wpewebkit.org";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ eval-exec ];
    platforms = with lib.platforms; linux ++ darwin;
    pkgConfigModules = [ "wpe-webkit-2.0" ];
  };
})
