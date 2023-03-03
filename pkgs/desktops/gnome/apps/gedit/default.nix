{ stdenv
, lib
, meson
, fetchurl
, python3
, pkg-config
, gtk3
, gtk-mac-integration
, glib
, amtk
, tepl
, libpeas
, libxml2
, gtksourceview4
, gsettings-desktop-schemas
, wrapGAppsHook
, gtk-doc
, docbook-xsl-nons
, ninja
, libsoup
, gnome
, gspell
, perl
, itstool
, desktop-file-utils
, vala
}:

stdenv.mkDerivation rec {
  pname = "gedit";
  version = "44.2";

  outputs = [ "out" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/gedit/${lib.versions.major version}/gedit-${version}.tar.xz";
    sha256 = "O7sbN3XUwnfa9UqqtEsOuDpOsfCfA5GAAEHJ5WiT7BE=";
  };

  patches = [
    # We patch gobject-introspection and meson to store absolute paths to libraries in typelibs
    # but that requires the install_dir is an absolute path.
    ./correct-gir-lib-path.patch
  ];

  nativeBuildInputs = [
    desktop-file-utils
    itstool
    libxml2
    meson
    ninja
    perl
    pkg-config
    python3
    vala
    wrapGAppsHook
    gtk-doc
    docbook-xsl-nons
  ];

  buildInputs = [
    amtk
    tepl
    glib
    gsettings-desktop-schemas
    gspell
    gtk3
    gtksourceview4
    libpeas
    libsoup
  ] ++ lib.optionals stdenv.isDarwin [
    gtk-mac-integration
  ];

  postPatch = ''
    chmod +x build-aux/meson/post_install.py
    chmod +x plugins/externaltools/scripts/gedit-tool-merge.pl
    patchShebangs build-aux/meson/post_install.py
    patchShebangs plugins/externaltools/scripts/gedit-tool-merge.pl
  '';

  # Reliably fails to generate gedit-file-browser-enum-types.h in time
  enableParallelBuilding = false;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gedit";
      attrPath = "gnome.gedit";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Gedit";
    description = "Official text editor of the GNOME desktop environment";
    maintainers = teams.gnome.members;
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
