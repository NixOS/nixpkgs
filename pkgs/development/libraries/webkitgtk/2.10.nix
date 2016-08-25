{ stdenv, fetchurl, fetchpatch, perl, python, ruby, bison, gperf, cmake
, pkgconfig, gettext, gobjectIntrospection, libnotify
, gtk2, gtk3, wayland, libwebp, enchant
, libxml2, libsoup, libsecret, libxslt, harfbuzz, libpthreadstubs
, enableGeoLocation ? false, geoclue2, sqlite, xorg
, enableCredentialStorage ? !stdenv.isDarwin
, gst-plugins-base, readline, libedit
}:

assert enableGeoLocation -> geoclue2 != null;
assert stdenv.isDarwin -> !enableCredentialStorage;

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "webkitgtk-${version}";
  version = "2.10.9";

  meta = {
    description = "Web content rendering engine, GTK+ port";
    homepage = "http://webkitgtk.org/";
    license = licenses.bsd2;
    platforms = platforms.linux;
    hydraPlatforms = [];
    maintainers = with maintainers; [ koral ];
  };

  preConfigure = "patchShebangs Tools";

  src = fetchurl {
    url = "http://webkitgtk.org/releases/${name}.tar.xz";
    sha256 = "0sg935wpkgyd5ypd5fj25vd7ri8s6sbrmssb53xbgcc02xs8vcdv";
  };

  patches = [
    ./finding-harfbuzz-icu.patch
  ] ++ optional stdenv.isDarwin ./adding-libintl.patch;

  cmakeFlags = [
    "-DPORT=GTK"
    "-DUSE_LIBHYPHEN=OFF"
  ] ++ optionals (!enableCredentialStorage) [
    "-DENABLE_CREDENTIAL_STORAGE=OFF"
  ] ++ optionals (!enableGeoLocation) [
    "-DENABLE_GEOLOCATION=OFF"
  ] ++ optionals stdenv.isDarwin [
    "-DENABLE_WEBKIT=ON"
    "-DENABLE_X11_TARGET=OFF"
    "-DENABLE_QUARTZ_TARGET=ON"
    "-DENABLE_TOOLS=ON"
    "-DENABLE_MINIBROWSER=ON"
    "-DENABLE_PLUGIN_PROCESS_GTK2=OFF"
    "-DENABLE_VIDEO=OFF"
    "-DENABLE_WEB_AUDIO=OFF"
    "-DENABLE_OPENGL=OFF"
    "-DENABLE_INTROSPECTION=OFF"
    "-DUSE_LIBNOTIFY=OFF"
    "-DCMAKE_SHARED_LINKER_FLAGS=-L/path/to/nonexistent/folder"
  ];

  # XXX: WebKit2 missing include path for gst-plugins-base.
  # Filled: https://bugs.webkit.org/show_bug.cgi?id=148894
  NIX_CFLAGS_COMPILE = "-I${gst-plugins-base.dev}/include/gstreamer-1.0";

  nativeBuildInputs = [
    cmake perl python ruby bison gperf sqlite
    pkgconfig gettext gobjectIntrospection
  ];

  buildInputs = [
    gtk2 libwebp enchant libnotify
    libxml2 libxslt harfbuzz libpthreadstubs
    gst-plugins-base xorg.libXt
  ] ++ optionals enableCredentialStorage [
    libsecret
  ] ++ (if stdenv.isDarwin then [
    readline libedit
  ] else [
    wayland
  ]) ++ optional enableGeoLocation geoclue2;

  propagatedBuildInputs = [
    libsoup gtk3
  ];

  enableParallelBuilding = true;
}
