{ stdenv, fetchurl, intltool, pkgconfig, gtk3, vala
, makeWrapper, gdk_pixbuf, cmake, desktop_file_utils
, libnotify, libcanberra, libsecret, gmime
, libpthreadstubs, sqlite
, gnome3, librsvg, gnome_doc_utils, webkitgtk }:

let
  majorVersion = "0.8";
in
stdenv.mkDerivation rec {
  name = "geary-${majorVersion}.2";

  src = fetchurl {
    url = "mirror://gnome/sources/geary/${majorVersion}/${name}.tar.xz";
    sha256 = "3cfa626168935acf49c9415fad54c7849f17fd833026cfd3c224ba0fb892d641";
  };

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  buildInputs = [ intltool pkgconfig gtk3 makeWrapper cmake desktop_file_utils gnome_doc_utils
                  vala webkitgtk libnotify libcanberra gnome3.libgee libsecret gmime sqlite
                  libpthreadstubs gnome3.gsettings_desktop_schemas gnome3.gcr
                  gdk_pixbuf librsvg gnome3.defaultIconTheme ];

  preConfigure = ''
    substituteInPlace src/CMakeLists.txt --replace '`pkg-config --variable=girdir gobject-introspection-1.0`' '${webkitgtk}/share/gir-1.0'
  '';

  postInstall = ''
    mkdir -p $out/share/gsettings-schemas/${name}/
    mv $out/share/glib-2.0 $out/share/gsettings-schemas/${name}
  '';

  preFixup = ''
    wrapProgram "$out/bin/geary" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:${gnome3.gnome_themes_standard}/share:$out/share:$GSETTINGS_SCHEMAS_PATH"
  '';

  enableParallelBuilding = true;

  patches = [ ./disable_valadoc.patch ];
  patchFlags = "-p0";

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Geary;
    description = "Mail client for GNOME 3";
    maintainers = gnome3.maintainers;
    license = licenses.lgpl2;
    platforms = platforms.linux;
  };
}
