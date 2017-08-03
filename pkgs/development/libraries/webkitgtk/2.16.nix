{ stdenv, fetchurl, perl, python2, ruby, bison, gperf, cmake
, pkgconfig, gettext, gobjectIntrospection, libnotify, gnutls
, gtk2, gtk3, wayland, libwebp, enchant, xlibs, libxkbcommon, epoxy, at_spi2_core
, libxml2, libsoup, libsecret, libxslt, harfbuzz, libpthreadstubs, pcre, nettle, libtasn1, p11_kit
, libidn, libedit, readline, mesa, libintlOrEmpty
, enableGeoLocation ? true, geoclue2, sqlite
, gst-plugins-base
}:

assert enableGeoLocation -> geoclue2 != null;

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "webkitgtk-${version}";
  version = "2.16.4";

  meta = {
    description = "Web content rendering engine, GTK+ port";
    homepage = http://webkitgtk.org/;
    license = licenses.bsd2;
    platforms = with platforms; linux ++ darwin;
    hydraPlatforms = [];
    maintainers = with maintainers; [ ];
  };

  postConfigure = optionalString stdenv.isDarwin ''
    substituteInPlace Source/WebKit2/CMakeFiles/WebKit2.dir/link.txt \
        --replace "../../lib/libWTFGTK.a" ""
    substituteInPlace Source/JavaScriptCore/CMakeFiles/JavaScriptCore.dir/link.txt \
        --replace "../../lib/libbmalloc.a" ""
    sed -i "s|[\./]*\.\./lib/lib[^\.]*\.a||g" \
        Source/JavaScriptCore/CMakeFiles/LLIntOffsetsExtractor.dir/link.txt \
        Source/JavaScriptCore/shell/CMakeFiles/jsc.dir/link.txt \
        Source/JavaScriptCore/shell/CMakeFiles/testb3.dir/link.txt \
        Source/WebKit2/CMakeFiles/DatabaseProcess.dir/link.txt \
        Source/WebKit2/CMakeFiles/NetworkProcess.dir/link.txt \
        Source/WebKit2/CMakeFiles/webkit2gtkinjectedbundle.dir/link.txt \
        Source/WebKit2/CMakeFiles/WebProcess.dir/link.txt
    substituteInPlace Source/JavaScriptCore/CMakeFiles/JavaScriptCore.dir/link.txt \
        --replace "../../lib/libWTFGTK.a" "-Wl,-all_load ../../lib/libWTFGTK.a"
  '';

  src = fetchurl {
    url = "http://webkitgtk.org/releases/${name}.tar.xz";
    sha256 = "0a2ikwiw1wn8w11y9ci6nn6dq9w0iki48l9lhnbm7g8rhcrs9azr";
  };

  # see if we can clean this up....

  patches = [ ./finding-harfbuzz-icu.patch ]
     ++ optionals stdenv.isDarwin [
    ./PR-152650-2.patch
    ./PR-153138.patch
    ./PR-157554.patch
    ./PR-157574.patch
  ];

  cmakeFlags = [
  "-DPORT=GTK"
  "-DUSE_LIBHYPHEN=0"
  ]
  ++ optional stdenv.isLinux "-DENABLE_GLES2=ON"
  ++ optionals stdenv.isDarwin [
  "-DUSE_SYSTEM_MALLOC=ON"
  "-DUSE_ACCELERATE=0"
  "-DENABLE_INTROSPECTION=ON"
  "-DENABLE_MINIBROWSER=OFF"
  "-DENABLE_PLUGIN_PROCESS_GTK2=OFF"
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

  # XXX: WebKit2 missing include path for gst-plugins-base.
  # Filled: https://bugs.webkit.org/show_bug.cgi?id=148894
  NIX_CFLAGS_COMPILE = "-I${gst-plugins-base.dev}/include/gstreamer-1.0"
                     + (optionalString stdenv.isDarwin " -lintl");

  nativeBuildInputs = [
    cmake perl python2 ruby bison gperf sqlite
    pkgconfig gettext gobjectIntrospection
  ];

  buildInputs = libintlOrEmpty ++ [
    gtk2 libwebp enchant libnotify gnutls pcre nettle libidn
    libxml2 libsecret libxslt harfbuzz libpthreadstubs libtasn1 p11_kit
    gst-plugins-base libxkbcommon epoxy at_spi2_core
  ] ++ optional enableGeoLocation geoclue2
    ++ (with xlibs; [ libXdmcp libXt libXtst ])
    ++ optionals stdenv.isDarwin [ libedit readline mesa ]
    ++ optional stdenv.isLinux wayland;

  propagatedBuildInputs = [
    libsoup gtk3
  ];

  enableParallelBuilding = true;
}
