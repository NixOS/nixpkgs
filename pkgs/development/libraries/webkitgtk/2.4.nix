{ stdenv, fetchurl, perl, python, ruby, bison, gperf, flex
, pkgconfig, which, gettext, gobjectIntrospection
, gtk2, gtk3, wayland, libwebp, enchant, sqlite
, libxml2, libsoup, libsecret, libxslt, harfbuzz
, gst-plugins-base
, withGtk2 ? false
, enableIntrospection ? true
}:

stdenv.mkDerivation rec {
  name = "webkitgtk-${version}";
  version = "2.4.9";

  meta = with stdenv.lib; {
    description = "Web content rendering engine, GTK+ port";
    homepage = "http://webkitgtk.org/";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = [];
  };

  src = fetchurl {
    url = "http://webkitgtk.org/releases/${name}.tar.xz";
    sha256 = "0r651ar3p0f8zwl7764kyimxk5hy88cwy116pv8cl5l8hbkjkpxg";
  };

  CC = "cc";

  prePatch = ''
    patchShebangs Tools/gtk
  '';
  patches = [ ./webcore-svg-libxml-cflags.patch ];

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
    libxml2 libsecret libxslt
    gst-plugins-base sqlite
  ];

  propagatedBuildInputs = [
    libsoup harfbuzz/*icu in *.la*/
    (if withGtk2 then gtk2 else gtk3)
  ];

  # Still fails with transient errors in version 2.4.9.
  enableParallelBuilding = false;

}
