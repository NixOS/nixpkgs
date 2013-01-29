{ fetchurl, stdenv, pkgconfig, intltool, perl, perlXMLParser, libxml2
, glib, gtk3, pango, atk, gdk_pixbuf
, itstool, gnome_icon_theme, libgnome_keyring, gsettings_desktop_schemas
, poppler, ghostscriptX, djvulibre, libspectre
, makeWrapper
, shared_mime_info
, recentListSize ? null # 5 is not enough, allow passing a different number
}:

stdenv.mkDerivation rec {
  name = "evince-3.6.1";

  src = fetchurl {
    url = "http://ftp.gnome.org/pub/GNOME/sources/evince/3.6/${name}.tar.xz";
    sha256 = "1da1pij030dh8mb0pr0jnyszgsbjnh8lc17rj5ii52j3kmbv51qv";
  };

  buildInputs = [
    pkgconfig intltool perl perlXMLParser libxml2
    glib gtk3 pango atk gdk_pixbuf
    itstool gnome_icon_theme libgnome_keyring gsettings_desktop_schemas
    poppler ghostscriptX djvulibre libspectre
    makeWrapper
  ];

  configureFlags = [
    "--disable-nautilus" # Do not use nautilus
    "--disable-dbus" # strange compilation error
  ];

  postUnpack = if recentListSize != null then ''
    sed -i 's/\(gtk_recent_chooser_set_limit .*\)5)/\1${builtins.toString recentListSize})/' */shell/ev-open-recent-action.c
    sed -i 's/\(if (++n_items == \)5\(.*\)/\1${builtins.toString recentListSize}\2/' */shell/ev-window.c
  '' else "";

  postInstall = ''
    # Tell Glib/GIO about the MIME info directory, which is used
    # by `g_file_info_get_content_type ()'.
    wrapProgram "$out/bin/evince" \
      --prefix XDG_DATA_DIRS : "${shared_mime_info}/share:$out/share"

    for pkg in "${gsettings_desktop_schemas}" "${gtk3}"; do
      cp -s $pkg/share/glib-2.0/schemas/*.gschema.xml $out/share/glib-2.0/schemas/
    done
    ${glib}/bin/glib-compile-schemas $out/share/glib-2.0/schemas/
  '';

  meta = {
    homepage = http://www.gnome.org/projects/evince/;
    description = "Evince, GNOME's document viewer";

    longDescription = ''
      Evince is a document viewer for multiple document formats.  It
      currently supports PDF, PostScript, DjVu, TIFF and DVI.  The goal
      of Evince is to replace the multiple document viewers that exist
      on the GNOME Desktop with a single simple application.
    '';

    license = "GPLv2+";
  };
}
