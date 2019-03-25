{ fetchurl, stdenv, pkgconfig, intltool, libxml2
, glib, gtk3, pango, atk, gdk_pixbuf, shared-mime-info, itstool, gnome3
, poppler, ghostscriptX, djvulibre, libspectre, libarchive, libsecret, wrapGAppsHook
, librsvg, gobject-introspection, yelp-tools, gspell, adwaita-icon-theme, gsettings-desktop-schemas
, nautilus
, libgxps
, gst_all_1
, recentListSize ? null # 5 is not enough, allow passing a different number
, supportXPS ? false    # Open XML Paper Specification via libgxps
, supportMultimedia ? true
, autoreconfHook, pruneLibtoolFiles
}:

stdenv.mkDerivation rec {
  name = "evince-${version}";
  version = "3.30.2";

  src = fetchurl {
    url = "mirror://gnome/sources/evince/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0k7jln6dpg4bpv61niicjzkzyq6fhb3yfld7pc8ck71c8pmvsnx9";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "evince"; };
  };

  nativeBuildInputs = [
    pkgconfig gobject-introspection intltool itstool wrapGAppsHook yelp-tools autoreconfHook pruneLibtoolFiles
  ];

  buildInputs = [
    glib gtk3 pango atk gdk_pixbuf libxml2
    gsettings-desktop-schemas
    poppler ghostscriptX djvulibre libspectre libarchive
    libsecret librsvg adwaita-icon-theme gspell
    nautilus
  ] ++ stdenv.lib.optional supportXPS libgxps
    ++ stdenv.lib.optionals supportMultimedia (with gst_all_1; [
      gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav ]);

  configureFlags = [
    "--enable-ps"
    "--enable-introspection"
    (if supportXPS then "--enable-xps" else "--disable-xps")
    (if supportMultimedia then "--enable-multimedia" else "--disable-multimedia")
  ];

  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  preConfigure = stdenv.lib.optionalString (recentListSize != null) ''
    sed -i 's/\(gtk_recent_chooser_set_limit .*\)5)/\1${builtins.toString recentListSize})/' shell/ev-open-recent-action.c
    sed -i 's/\(if (++n_items == \)5\(.*\)/\1${builtins.toString recentListSize}\2/' shell/ev-window.c
  '';

  preFixup = ''
    gappsWrapperArgs+=(--prefix XDG_DATA_DIRS : "${shared-mime-info}/share")
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Evince;
    description = "GNOME's document viewer";

    longDescription = ''
      Evince is a document viewer for multiple document formats.  It
      currently supports PDF, PostScript, DjVu, TIFF and DVI.  The goal
      of Evince is to replace the multiple document viewers that exist
      on the GNOME Desktop with a single simple application.
    '';

    license = stdenv.lib.licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = gnome3.maintainers ++ [ maintainers.vcunat ];
  };
}
