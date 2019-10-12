{ stdenv, fetchurl, perl, python2, ruby, bison, gperf, cmake, ninja
, pkgconfig, gettext, gobject-introspection, libnotify, gnutls, libgcrypt
, gtk3, wayland, libwebp, enchant2, xorg, libxkbcommon, epoxy, at-spi2-core
, libxml2, libsoup, libsecret, libxslt, harfbuzz, libpthreadstubs, pcre, nettle, libtasn1, p11-kit
, libidn, libedit, readline, libGLU_combined, libintl, openjpeg
, enableGeoLocation ? true, geoclue2, sqlite
, enableGtk2Plugins ? false, gtk2 ? null
, gst-plugins-base, gst-plugins-bad, woff2
, bubblewrap, libseccomp, xdg-dbus-proxy, substituteAll
}:

assert enableGeoLocation -> geoclue2 != null;
assert enableGtk2Plugins -> gtk2 != null;
assert stdenv.isDarwin -> !enableGtk2Plugins;

with stdenv.lib;
stdenv.mkDerivation rec {
  pname = "webkitgtk";
  version = "2.26.1";

  meta = {
    description = "Web content rendering engine, GTK port";
    homepage = https://webkitgtk.org/;
    license = licenses.bsd2;
    platforms = platforms.linux;
    hydraPlatforms = [];
    maintainers = with maintainers; [ ];
  };

  src = fetchurl {
    url = "https://webkitgtk.org/releases/${pname}-${version}.tar.xz";
    sha256 = "0mfikjfjhwcnrxbzdyh3fl9bbs2azgbdnx8h5910h41b3n022jvb";
  };

  patches = optionals stdenv.isLinux [
    (substituteAll {
      src = ./fix-bubblewrap-paths.patch;
      inherit (builtins) storeDir;
    })
  ];

  postPatch = ''
    patchShebangs .
  '';

  cmakeFlags = [
  "-DPORT=GTK"
  "-DUSE_LIBHYPHEN=OFF"
  "-DENABLE_INTROSPECTION=ON"
  "-DUSE_WPE_RENDERER=OFF"
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
    pkgconfig gettext gobject-introspection
  ];

  buildInputs = [
    libintl libwebp enchant2 libnotify gnutls pcre nettle libidn libgcrypt woff2
    libxml2 libsecret libxslt harfbuzz libpthreadstubs libtasn1 p11-kit openjpeg
    sqlite gst-plugins-base gst-plugins-bad libxkbcommon epoxy at-spi2-core
  ] ++ optional enableGeoLocation geoclue2
    ++ optional enableGtk2Plugins gtk2
    ++ (with xorg; [ libXdmcp libXt libXtst libXdamage ])
    ++ optionals stdenv.isDarwin [ libedit readline libGLU_combined ]
    ++ optionals stdenv.isLinux [
      wayland bubblewrap libseccomp xdg-dbus-proxy
  ];

  propagatedBuildInputs = [
    libsoup gtk3
  ];

  outputs = [ "out" "dev" ];

}
