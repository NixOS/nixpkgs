{ stdenv
, lib
, fetchurl
, meson
, ninja
, pkg-config
, gnome
, gtk3
, wrapGAppsHook
, glib
, appstream-glib
, gobject-introspection
, python3
, gi-docgen
, webkitgtk_4_1
, gettext
, itstool
, gsettings-desktop-schemas
, shared-mime-info
}:

stdenv.mkDerivation rec {
  pname = "devhelp";
  version = "43.beta";

  outputs = [ "out" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/devhelp/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "cVgG50RPktYW2xuI8Qq3zy9sFNrQDXhBqtz9x3ZJmTE=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    itstool
    wrapGAppsHook
    appstream-glib
    gobject-introspection
    python3
    gi-docgen
  ];

  buildInputs = [
    glib
    gtk3
    webkitgtk_4_1
    gnome.adwaita-icon-theme
    gsettings-desktop-schemas
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
  ];

  doCheck = true;

  postPatch = ''
    # patchShebangs requires executable file
    chmod +x build-aux/meson/meson_post_install.py
    patchShebangs build-aux/meson/meson_post_install.py
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      # Fix pages being blank
      # https://gitlab.gnome.org/GNOME/devhelp/issues/14
      --prefix XDG_DATA_DIRS : "${shared-mime-info}/share"
    )
  '';

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput share/doc/devhelp-3 "$devdoc"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "devhelp";
      attrPath = "gnome.devhelp";
    };
  };

  meta = with lib; {
    description = "API documentation browser for GNOME";
    homepage = "https://wiki.gnome.org/Apps/Devhelp";
    license = licenses.gpl3Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
