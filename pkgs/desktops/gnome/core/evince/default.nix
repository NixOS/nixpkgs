{ lib
, stdenv
, fetchurl
, meson
, ninja
, pkg-config
, gettext
, libxml2
, appstream
, desktop-file-utils
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
, texlive
, gst_all_1
, gi-docgen
, supportMultimedia ? true # PDF multimedia
, libgxps
, supportXPS ? true # Open XML Paper Specification via libgxps
, withLibsecret ? true
}:

stdenv.mkDerivation rec {
  pname = "evince";
  version = "44.3";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/evince/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "O4uhWBpHpun1f2tqoI8PtnVJxgEhqiTjEUDpOUe4NiI=";
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    appstream
    desktop-file-utils
    gettext
    gobject-introspection
    gi-docgen
    itstool
    meson
    ninja
    pkg-config
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
  ]);

  mesonFlags = [
    "-Dnautilus=false"
    "-Dps=enabled"
  ] ++ lib.optionals (!withLibsecret) [
    "-Dkeyring=disabled"
  ] ++ lib.optionals (!supportMultimedia) [
    "-Dmultimedia=disabled"
  ];

  env.NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  preFixup = ''
    gappsWrapperArgs+=(--prefix XDG_DATA_DIRS : "${shared-mime-info}/share")
  '';

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
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
    platforms = platforms.unix;
    maintainers = teams.gnome.members ++ teams.pantheon.members;
  };
}
