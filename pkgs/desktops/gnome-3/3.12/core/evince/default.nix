{ fetchurl, stdenv, pkgconfig, intltool, perl, perlXMLParser, libxml2
, glib, gtk3, pango, atk, gdk_pixbuf, shared_mime_info, itstool, gnome3
, poppler, ghostscriptX, djvulibre, libspectre, libsecret , makeWrapper
, librsvg, recentListSize ? null # 5 is not enough, allow passing a different number
, gobjectIntrospection
}:

stdenv.mkDerivation rec {
  name = "evince-3.12.2";

  src = fetchurl {
    url = "mirror://gnome/sources/evince/3.12/${name}.tar.xz";
    sha256 = "30c243bbfde56338c25a39003b4848143be42157177e2163a368f14139909f7d";
  };

  buildInputs = [
    pkgconfig intltool perl perlXMLParser libxml2
    glib gtk3 pango atk gdk_pixbuf gobjectIntrospection
    itstool gnome3.gnome_icon_theme gnome3.gnome_icon_theme_symbolic
    gnome3.libgnome_keyring gnome3.gsettings_desktop_schemas
    poppler ghostscriptX djvulibre libspectre
    makeWrapper libsecret librsvg
  ];

  configureFlags = [
    "--disable-nautilus" # Do not use nautilus
    "--enable-introspection"
  ];

  NIX_CFLAGS_COMPILE = "-I${gnome3.glib}/include/gio-unix-2.0";

  preConfigure = with stdenv.lib;
    optionalString doCheck ''
      for file in test/*.py; do
        echo "patching $file"
        sed '1s,/usr,${python},' -i "$file"
      done
    '' + optionalString (recentListSize != null) ''
      sed -i 's/\(gtk_recent_chooser_set_limit .*\)5)/\1${builtins.toString recentListSize})/' shell/ev-open-recent-action.c
      sed -i 's/\(if (++n_items == \)5\(.*\)/\1${builtins.toString recentListSize}\2/' shell/ev-window.c
    '';

  preFixup = ''
    # Tell Glib/GIO about the MIME info directory, which is used
    # by `g_file_info_get_content_type ()'.
    wrapProgram "$out/bin/evince" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:${gtk3}/share:${shared_mime_info}/share:$out/share:$GSETTINGS_SCHEMAS_PATH"
  '';

  doCheck = false; # would need pythonPackages.dogTail, which is missing

  meta = with stdenv.lib; {
    homepage = http://www.gnome.org/projects/evince/;
    description = "GNOME's document viewer";

    longDescription = ''
      Evince is a document viewer for multiple document formats.  It
      currently supports PDF, PostScript, DjVu, TIFF and DVI.  The goal
      of Evince is to replace the multiple document viewers that exist
      on the GNOME Desktop with a single simple application.
    '';

    license = stdenv.lib.licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.vcunat ];
  };
}
