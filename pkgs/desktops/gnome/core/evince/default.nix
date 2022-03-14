{ lib
, stdenv
, fetchurl
, fetchpatch
, meson
, ninja
, pkg-config
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
, gnome
, poppler
, ghostscriptX
, djvulibre
, libspectre
, libarchive
, libhandy
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
, pantheon
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
, withPantheon ? false
, withLibsecret ? true
}:

stdenv.mkDerivation rec {
  pname = "evince";
  version = "41.4";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/evince/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "/yRSQPIwkivsMqTXsKHZGyR6g9E0hPmbdANdUesjITA=";
  };

  patches = lib.optionals withPantheon [
    # Make this respect dark mode settings from Pantheon
    # https://github.com/elementary/evince/pull/21
    # https://github.com/elementary/evince/pull/31
    (fetchpatch {
      url = "https://raw.githubusercontent.com/elementary/evince/c8364019ee2c2dffd2a1bccf79b8f4e526aa22af/dark-style.patch";
      sha256 = "sha256-nKELRXnM6gMRTGmWdO1Qqlo9ciy+4HOK5z2CYOoi2Lo=";
    })
  ];

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
    pkg-config
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
    libhandy
    librsvg
    libspectre
    libxml2
    pango
    poppler
    t1lib
    texlive.bin.core # kpathsea for DVI support
  ] ++ lib.optionals withLibsecret [
    libsecret
  ] ++ lib.optionals supportXPS [
    libgxps
  ] ++ lib.optionals supportMultimedia (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
    gst-libav
  ]) ++ lib.optionals withPantheon [
    pantheon.granite
  ];

  mesonFlags = [
    "-Dnautilus=false"
    "-Dps=enabled"
  ] ++ lib.optionals (!withLibsecret) [
    "-Dkeyring=disabled"
  ];

  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  preFixup = ''
    gappsWrapperArgs+=(--prefix XDG_DATA_DIRS : "${shared-mime-info}/share")
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Evince";
    description = "GNOME's document viewer";

    longDescription = ''
      Evince is a document viewer for multiple document formats.  It
      currently supports PDF, PostScript, DjVu, TIFF and DVI.  The goal
      of Evince is to replace the multiple document viewers that exist
      on the GNOME Desktop with a single simple application.
    '';

    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = teams.gnome.members ++ teams.pantheon.members;
  };
}
