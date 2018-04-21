{ stdenv, fetchurl, perl, python2, ruby, bison, gperf, cmake, ninja
, pkgconfig, gettext, gobjectIntrospection, libnotify, gnutls, libgcrypt
, gtk3, wayland, libwebp, enchant2, xorg, libxkbcommon, epoxy, at-spi2-core
, libxml2, libsoup, libsecret, libxslt, harfbuzz, libpthreadstubs, pcre, nettle, libtasn1, p11-kit
, libidn, libedit, readline, libGLU_combined, libintl
, enableGeoLocation ? true, geoclue2, sqlite
, enableGtk2Plugins ? false, gtk2 ? null
, gst-plugins-base, gst-plugins-bad, woff2
}:

assert enableGeoLocation -> geoclue2 != null;
assert enableGtk2Plugins -> gtk2 != null;
assert stdenv.isDarwin -> !enableGtk2Plugins;

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "webkitgtk-${version}";
  version = "2.20.1";

  meta = {
    description = "Web content rendering engine, GTK+ port";
    homepage = https://webkitgtk.org/;
    license = licenses.bsd2;
    platforms = with platforms; linux ++ darwin;
    hydraPlatforms = [];
    maintainers = with maintainers; [ ];
  };

  src = fetchurl {
    url = "http://webkitgtk.org/releases/${name}.tar.xz";
    sha256 = "0nc9dj05dbk31ciip08b3rdsfja7ckc5mgagrj030fafza2k5r23";
  };

  patches = optionals stdenv.isDarwin [
    ## TODO add necessary patches for Darwin
  ];

  postPatch = ''
    patchShebangs .
  '';

  postConfigure = ''
    # A stopgap for a non-deterministic build failure when using only one core
    # Upstream bug: https://bugs.webkit.org/show_bug.cgi?id=183788#c4
    ninja JavaScriptCoreForwardingHeaders WTFForwardingHeaders
  '';

  cmakeFlags = [
  "-DPORT=GTK"
  "-DUSE_LIBHYPHEN=0"
  "-DENABLE_INTROSPECTION=ON"
  ]
  ++ optional (!enableGtk2Plugins) "-DENABLE_PLUGIN_PROCESS_GTK2=OFF"
  ++ optional stdenv.isLinux "-DENABLE_GLES2=ON"
  ++ optionals stdenv.isDarwin [
  "-DUSE_SYSTEM_MALLOC=ON"
  "-DUSE_ACCELERATE=0"
  "-DENABLE_MINIBROWSER=OFF"
  "-DENABLE_VIDEO=ON"
  "-DENABLE_QUARTZ_TARGET=ON"
  "-DENABLE_X11_TARGET=OFF"
  "-DENABLE_OPENGL=OFF"
  "-DENABLE_WEB_AUDIO=OFF"
  "-DENABLE_WEBGL=OFF"
  "-DENABLE_GRAPHICS_CONTEXT_3D=OFF"
  "-DENABLE_GTKDOC=OFF"
  ];

  nativeBuildInputs = [
    cmake ninja perl python2 ruby bison gperf
    pkgconfig gettext gobjectIntrospection
  ];

  buildInputs = [
    libintl libwebp enchant2 libnotify gnutls pcre nettle libidn libgcrypt woff2
    libxml2 libsecret libxslt harfbuzz libpthreadstubs libtasn1 p11-kit
    sqlite gst-plugins-base gst-plugins-bad libxkbcommon epoxy at-spi2-core
  ] ++ optional enableGeoLocation geoclue2
    ++ optional enableGtk2Plugins gtk2
    ++ (with xorg; [ libXdmcp libXt libXtst libXdamage ])
    ++ optionals stdenv.isDarwin [ libedit readline libGLU_combined ]
    ++ optional stdenv.isLinux wayland;

  propagatedBuildInputs = [
    libsoup gtk3
  ];

  outputs = [ "out" "dev" ];
}
