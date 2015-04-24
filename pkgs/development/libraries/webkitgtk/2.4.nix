{ stdenv, fetchurl, autoreconfHook, perl, python, ruby, bison, gperf, flex
, pkgconfig, which, gettext, gobjectIntrospection
, gtk2, gtk3, wayland, libwebp, enchant, sqlite
, libxml2, libsoup, libsecret, libxslt, harfbuzz
, gst-plugins-base
, withGtk2 ? false
, enableIntrospection ? true
}:

stdenv.mkDerivation rec {
  name = "webkitgtk-${version}";
  version = "2.4.8";

  meta = with stdenv.lib; {
    description = "Web content rendering engine, GTK+ port";
    homepage = "http://webkitgtk.org/";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = [ maintainers.iyzsong ];
  };

  src = fetchurl {
    url = "http://webkitgtk.org/releases/${name}.tar.xz";
    sha256 = "08xxqsxpa63nzgbsz63vrdxdxgpysyiy7jdcjb57k1hprdcibwb8";
  };

  patches = [ ./webkitgtk-2.4-gmutexlocker.patch ./bug140241.patch ];

  CC = "cc";

  prePatch = ''
    patchShebangs Tools/gtk
  '';

  # patch *.in between autoreconf and configure
  postAutoreconf = "patch -p1 < ${./webcore-svg-libxml-cflags.patch}";

  configureFlags = with stdenv.lib; [
    "--disable-geolocation"
    (optionalString enableIntrospection "--enable-introspection")
  ] ++ stdenv.lib.optional withGtk2 [
    "--with-gtk=2.0"
    "--disable-webkit2"
  ];

  dontAddDisableDepTrack = true;

  nativeBuildInputs = [
    autoreconfHook/*bug140241.patch*/ perl python ruby bison gperf flex
    pkgconfig which gettext gobjectIntrospection
  ];

  buildInputs = [
    gtk2 wayland libwebp enchant
    libxml2 libsecret libxslt harfbuzz
    gst-plugins-base sqlite
  ];

  propagatedBuildInputs = [
    libsoup
    (if withGtk2 then gtk2 else gtk3)
  ];

  # Probably OK now, see:
  # https://bugs.webkit.org/show_bug.cgi?id=79498
  enableParallelBuilding = true;
}

