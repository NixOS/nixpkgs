{ fetchurl, stdenv, pkgconfig, intltool, libxml2
, glib, gtk3, pango, atk, gdk_pixbuf, shared-mime-info, itstool, gnome3
, poppler, ghostscriptX, djvulibre, libspectre, libsecret, wrapGAppsHook
, librsvg, gobjectIntrospection, yelp-tools
, recentListSize ? null # 5 is not enough, allow passing a different number
, supportXPS ? false    # Open XML Paper Specification via libgxps
, autoreconfHook
}:

stdenv.mkDerivation rec {
  name = "evince-${version}";
  version = "3.28.0";

  src = fetchurl {
    url = "mirror://gnome/sources/evince/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "1a3kcls18dcz1lj8hrx8skcli9xxfyi71c17xjwayh71cm5jc8zs";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "evince"; };
  };

  nativeBuildInputs = [
    pkgconfig gobjectIntrospection intltool itstool wrapGAppsHook yelp-tools autoreconfHook
  ];

  buildInputs = [
    glib gtk3 pango atk gdk_pixbuf libxml2
    gnome3.gsettings-desktop-schemas
    poppler ghostscriptX djvulibre libspectre
    libsecret librsvg gnome3.adwaita-icon-theme
  ] ++ stdenv.lib.optional supportXPS gnome3.libgxps;

  configureFlags = [
    "--disable-nautilus" # Do not build nautilus plugin
    "--enable-introspection"
    (if supportXPS then "--enable-xps" else "--disable-xps")
  ];

  NIX_CFLAGS_COMPILE = "-I${gnome3.glib.dev}/include/gio-unix-2.0";

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
