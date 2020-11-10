{ stdenv
, fetchurl
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
, gdk-pixbuf
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
, gtk-doc
, docbook-xsl-nons
, docbook_xml_dtd_43
, supportMultimedia ? true # PDF multimedia
, libgxps
, supportXPS ? true # Open XML Paper Specification via libgxps
}:

stdenv.mkDerivation rec {
  pname = "evince";
  version = "3.38.0";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/evince/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0j0ry0y9qi1mlm7dcjwrmrw45s1225ri8sv0s9vb8ibm85x8kpr6";
  };

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  nativeBuildInputs = [
    appstream
    docbook-xsl-nons
    docbook_xml_dtd_43
    gettext
    gobject-introspection
    gtk-doc
    itstool
    meson
    ninja
    pkgconfig
    python3
    wrapGAppsHook
    yelp-tools
  ];

  buildInputs = [
    adwaita-icon-theme
    atk
    dbus # only needed to find the service directory
    djvulibre
    gdk-pixbuf
    ghostscriptX
    glib
    gnome-desktop
    gsettings-desktop-schemas
    gspell
    gtk3
    libarchive
    librsvg
    libsecret
    libspectre
    libxml2
    pango
    poppler
    t1lib
    texlive.bin.core # kpathsea for DVI support
  ] ++ stdenv.lib.optional supportXPS libgxps
    ++ stdenv.lib.optionals supportMultimedia (with gst_all_1; [
      gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav ]);

  mesonFlags = [
    "-Dnautilus=false"
    "-Dps=enabled"
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
    homepage = "https://wiki.gnome.org/Apps/Evince";
    description = "GNOME's document viewer";

    longDescription = ''
      Evince is a document viewer for multiple document formats.  It
      currently supports PDF, PostScript, DjVu, TIFF and DVI.  The goal
      of Evince is to replace the multiple document viewers that exist
      on the GNOME Desktop with a single simple application.
    '';

    license = stdenv.lib.licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = teams.gnome.members;
  };
}
