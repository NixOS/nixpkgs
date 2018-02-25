{ stdenv, fetchurl, perl, python2, ruby, bison, gperf, cmake
, pkgconfig, gettext, gobjectIntrospection, libnotify, gnutls
, gtk3, wayland, libwebp, enchant, xlibs, libxkbcommon, epoxy, at-spi2-core
, libxml2, libsoup, libsecret, libxslt, harfbuzz, libpthreadstubs, pcre, nettle, libtasn1, p11-kit
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
  version = "2.18.6";

  meta = {
    description = "Web content rendering engine, GTK+ port";
    homepage = https://webkitgtk.org/;
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
    sha256 = "0g5cpdijjv5hlrbi4i4dh97yrh5apnyvm90wpr9f84hgyk12r4ck";
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
  ++ optional (!enableGtk2Plugins) "-DENABLE_PLUGIN_PROCESS_GTK2=OFF"
  ++ optional stdenv.isLinux "-DENABLE_GLES2=ON"
  ++ optionals stdenv.isDarwin [
  "-DUSE_SYSTEM_MALLOC=ON"
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
    libxml2 libsecret libxslt harfbuzz libpthreadstubs libtasn1 p11-kit
    sqlite gst-plugins-base gst-plugins-bad libxkbcommon epoxy at-spi2-core
  ] ++ optional enableGeoLocation geoclue2
    ++ optional enableGtk2Plugins gtk2
    ++ (with xlibs; [ libXdmcp libXt libXtst ])
    ++ optionals stdenv.isDarwin [ libedit readline mesa ]
    ++ optional stdenv.isLinux wayland;

  propagatedBuildInputs = [
    libsoup gtk3
  ];

  enableParallelBuilding = true;

  outputs = [ "out" "dev" ];
}
