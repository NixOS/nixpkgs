{ lib
, stdenv
, fetchurl
, meson
, ninja
, gettext
, itstool
, pkg-config
, libxml2
, libjpeg
, libpeas
, libportal-gtk3
, gnome
, gtk3
, libhandy
, glib
, gsettings-desktop-schemas
, gnome-desktop
, lcms2
, gdk-pixbuf
, exempi
, shared-mime-info
, wrapGAppsHook3
, libjxl
, librsvg
, webp-pixbuf-loader
, libheif
, libexif
, gobject-introspection
, gi-docgen
}:

stdenv.mkDerivation rec {
  pname = "eog";
  version = "45.3";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-hlD2YtSSHYOnkE9rucokW69zX3F7R/rFs38NkOXokag=";
  };

  patches = [
    # Fix path to libeog.so in the gir file.
    # We patch gobject-introspection to hardcode absolute paths but
    # our Meson patch will only pass the info when install_dir is absolute as well.
    ./fix-gir-lib-path.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    itstool
    wrapGAppsHook3
    libxml2 # for xmllint for xml-stripblanks
    gobject-introspection
    gi-docgen
  ];

  buildInputs = [
    libjpeg
    libportal-gtk3
    gtk3
    libhandy
    gdk-pixbuf
    glib
    libpeas
    librsvg
    lcms2
    gnome-desktop
    libexif
    exempi
    gsettings-desktop-schemas
    shared-mime-info
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
  ];

  postInstall = ''
    # Pull in WebP and JXL support for gnome-backgrounds.
    # In postInstall to run before gappsWrapperArgsHook.
    export GDK_PIXBUF_MODULE_FILE="${gnome._gdkPixbufCacheBuilder_DO_NOT_USE {
      extraLoaders = [
        libjxl
        librsvg
        webp-pixbuf-loader
        libheif.out
      ];
    }}"
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      # Thumbnailers
      --prefix XDG_DATA_DIRS : "${gdk-pixbuf}/share"
      --prefix XDG_DATA_DIRS : "${libjxl}/share"
      --prefix XDG_DATA_DIRS : "${librsvg}/share"
      --prefix XDG_DATA_DIRS : "${shared-mime-info}/share"
    )
  '';

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "gnome.${pname}";
    };
  };

  meta = with lib; {
    description = "GNOME image viewer";
    homepage = "https://gitlab.gnome.org/GNOME/eog";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.unix;
    mainProgram = "eog";
  };
}
