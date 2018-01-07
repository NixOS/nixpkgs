{ stdenv, fetchurl, perl, python2, ruby, bison, gperf, cmake
, pkgconfig, gettext, gobjectIntrospection, libnotify, gnutls
, gtk3, wayland, libwebp, enchant, xlibs, libxkbcommon, epoxy, at_spi2_core
, libxml2, libsoup, libsecret, libxslt, harfbuzz, libpthreadstubs, pcre, nettle, libtasn1, p11_kit
, libidn, libedit, readline, mesa, libintlOrEmpty
, enableGeoLocation ? true, geoclue2, sqlite
, enableGtk2Plugins ? false, gtk2 ? null
, gst-plugins-base, gst-plugins-bad
}:

assert enableGeoLocation -> geoclue2 != null;
assert enableGtk2Plugins -> gtk2 != null;
assert stdenv.isDarwin -> !enableGtk2Plugins;

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "webkitgtk-${version}";
  version = "2.18.4";

  meta = {
    description = "Web content rendering engine, GTK+ port";
    homepage = https://webkitgtk.org/;
    license = licenses.bsd2;
    platforms = with platforms; linux ++ darwin;
    hydraPlatforms = [];
    maintainers = with maintainers; [ ];
  };

  postPatch = optionalString stdenv.isDarwin ''
    sed -i 's/^target_link_libraries(webkit2gtkinjectedbundle WebKit2*/\0 WebCore/' \
        Source/WebKit/PlatformGTK.cmake
  '';

  postConfigure = optionalString stdenv.isDarwin ''
    substituteInPlace Source/WebKit/CMakeFiles/WebKit2.dir/link.txt \
        --replace "../../lib/libWTFGTK.a" ""
    sed -i "s|[\./]*\.\./lib/lib[^\.]*\.a||g" \
        Source/JavaScriptCore/CMakeFiles/LLIntOffsetsExtractor.dir/link.txt \
        Source/JavaScriptCore/shell/CMakeFiles/jsc.dir/link.txt \
        Source/JavaScriptCore/shell/CMakeFiles/testb3.dir/link.txt \
        Source/WebKit/CMakeFiles/StorageProcess.dir/link.txt \
        Source/WebKit/CMakeFiles/NetworkProcess.dir/link.txt \
        Source/WebKit/CMakeFiles/webkit2gtkinjectedbundle.dir/link.txt \
        Source/WebKit/CMakeFiles/WebProcess.dir/link.txt
    substituteInPlace Source/JavaScriptCore/CMakeFiles/JavaScriptCore.dir/link.txt \
        --replace "../../lib/libWTFGTK.a" "-Wl,-all_load ../../lib/libWTFGTK.a"
  '';

  src = fetchurl {
    url = "http://webkitgtk.org/releases/${name}.tar.xz";
    sha256 = "1f1j0r996l20cgkvbwpizn7d4yp58cy334b1pvn4kfb5c2dbpdl7";
  };

  # see if we can clean this up....

  patches = [ ./finding-harfbuzz-icu.patch ]
     ++ optionals stdenv.isDarwin [
    ./PR-152650-2.patch
    ./PR-153138.patch
    ./bmalloc-mac.patch
  ];

  cmakeFlags = [
  "-DPORT=GTK"
  "-DUSE_LIBHYPHEN=0"
  ]
  ++ optional (!enableGtk2Plugins) "-DENABLE_PLUGIN_PROCESS_GTK2=OFF"
  ++ optional stdenv.isLinux "-DENABLE_GLES2=ON"
  ++ optionals stdenv.isDarwin [
  "-DUSE_ACCELERATE=0"
  "-DENABLE_INTROSPECTION=ON"
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

  NIX_CFLAGS_COMPILE = optionalString stdenv.isDarwin " -lintl";

  nativeBuildInputs = [
    cmake perl python2 ruby bison gperf
    pkgconfig gettext gobjectIntrospection
  ];

  buildInputs = libintlOrEmpty ++ [
    libwebp enchant libnotify gnutls pcre nettle libidn
    libxml2 libsecret libxslt harfbuzz libpthreadstubs libtasn1 p11_kit
    sqlite gst-plugins-base libxkbcommon epoxy at_spi2_core
  ] ++ optional enableGeoLocation geoclue2
    ++ optional enableGtk2Plugins gtk2
    ++ (with xlibs; [ libXdmcp libXt libXtst ])
    ++ optionals stdenv.isDarwin [ libedit readline mesa ]
    ++ optionals stdenv.isLinux [ wayland gst-plugins-bad ];

  propagatedBuildInputs = [
    libsoup gtk3
  ];

  enableParallelBuilding = true;

  outputs = [ "out" "dev" ];
}
