{ fetchurl
, stdenv
, autoreconfHook
, pkgconfig
, gettext
, libxml2
, appstream
, glib
, gtk3
, pango
, atk
, gdk_pixbuf
, shared-mime-info
, itstool
, gnome3
, poppler
, ghostscriptX
, djvulibre
, libspectre
, libarchive
, libsecret
, wrapGAppsHook
, librsvg
, gobject-introspection
, yelp-tools
, gspell
, adwaita-icon-theme
, gsettings-desktop-schemas
, libgxps
, supportXPS ? false # Open XML Paper Specification via libgxps
}:

stdenv.mkDerivation rec {
  pname = "evince";
  version = "3.32.0";

  src = fetchurl {
    url = "mirror://gnome/sources/evince/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0h2c6b2h6g3zy0gnycrjk1y7rp0kf7ppci76dmd2zvb6chhpgngh";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkgconfig
    gobject-introspection
    gettext
    itstool
    yelp-tools
    appstream
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gtk3
    pango
    atk
    gdk_pixbuf
    libxml2
    gsettings-desktop-schemas
    poppler
    ghostscriptX
    djvulibre
    libspectre
    libarchive
    libsecret
    librsvg
    adwaita-icon-theme
    gspell
  ] ++ stdenv.lib.optional supportXPS libgxps;

  configureFlags = [
    "--disable-nautilus" # Do not build nautilus plugin
    "--enable-ps"
    "--enable-introspection"
    (if supportXPS then "--enable-xps" else "--disable-xps")
  ];

  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  preFixup = ''
    gappsWrapperArgs+=(--prefix XDG_DATA_DIRS : "${shared-mime-info}/share")
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

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
