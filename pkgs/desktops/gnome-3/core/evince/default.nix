{ fetchFromGitLab
, stdenv
, meson
, ninja
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
, gnome-desktop
, dbus
, python3
, texlive
, t1lib
, gst_all_1
, supportMultimedia ? true # PDF multimedia
, libgxps
, supportXPS ? true # Open XML Paper Specification via libgxps
}:

stdenv.mkDerivation rec {
  pname = "evince";
  version = "3.32.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = pname;
    rev = version;
    sha256 = "1klq8j70q8r8hyqv1wi6jcx8g76yh46bh8614y82zzggn4cx6y3r";
  };

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    gobject-introspection
    gettext
    itstool
    yelp-tools
    appstream
    wrapGAppsHook
    python3
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
    gnome-desktop
    dbus # only needed to find the service directory
    texlive.bin.core # kpathsea for DVI support
    t1lib
  ] ++ stdenv.lib.optional supportXPS libgxps
    ++ stdenv.lib.optionals supportMultimedia (with gst_all_1; [
      gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav ]);

  mesonFlags = [
    "-Dauto_features=enabled"
    "-Dnautilus=false"
    "-Dps=enabled"
    "-Dgtk_doc=false"
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
