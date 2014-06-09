{ stdenv, fetchurl, perl, python, ruby, bison, gperf, flex
, pkgconfig, which, gettext, gobjectIntrospection
, gtk2, gtk3, wayland, libwebp, enchant
, libxml2, libsoup, libsecret, libxslt, harfbuzz
, gst-plugins-base
, withGtk2 ? false
, enableIntrospection ? true
}:

stdenv.mkDerivation rec {
  name = "webkitgtk-2.4.3";

  meta = {
    description = "Web content rendering engine, GTK+ port";
    homepage = "http://webkitgtk.org/";
    license = stdenv.lib.licenses.bsd2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ iyzsong ];
  };

  src = fetchurl {
    url = "http://webkitgtk.org/releases/${name}.tar.xz";
    sha256 = "1b6fm1c5kk6vl0llalsd605raqs152hn14635kjwcb6iq7mc6qlq";
  };

  patches = [ ./webcore-svg-libxml-cflags.patch ];

  CC = "cc";

  prePatch = ''
    patchShebangs Tools/gtk
  '';

  configureFlags = with stdenv.lib; [
    "--disable-geolocation"
    (optionalString enableIntrospection "--enable-introspection")
  ] ++ stdenv.lib.optional withGtk2 [
    "--with-gtk=2.0"
    "--disable-webkit2"
  ];

  dontAddDisableDepTrack = true;

  nativeBuildInputs = [
    perl python ruby bison gperf flex
    pkgconfig which gettext gobjectIntrospection
  ];

  buildInputs = [
    gtk2 wayland libwebp enchant
    libxml2 libsecret libxslt harfbuzz
    gst-plugins-base
  ];

  propagatedBuildInputs = [
    libsoup
    (if withGtk2 then gtk2 else gtk3)
  ];

  #enableParallelBuilding = true; # build problems on Hydra
}
