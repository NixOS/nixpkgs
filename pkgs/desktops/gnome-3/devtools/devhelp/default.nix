{ lib, stdenv
, fetchurl
, meson
, ninja
, pkg-config
, gnome3
, gtk3
, wrapGAppsHook
, glib
, amtk
, appstream-glib
, gobject-introspection
, python3
, webkitgtk
, gettext
, itstool
, gsettings-desktop-schemas
, shared-mime-info
}:

stdenv.mkDerivation rec {
  pname = "devhelp";
  version = "3.38.1";

  src = fetchurl {
    url = "mirror://gnome/sources/devhelp/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "13sa25mmlc49kn520hdfbskma65y7smvwmyhfggj0n9s3fazba2d";
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
  ];

  buildInputs = [
    glib
    gtk3
    webkitgtk
    amtk
    gnome3.adwaita-icon-theme
    gsettings-desktop-schemas
  ];

  doCheck = true;

  postPatch = ''
    chmod +x meson_post_install.py # patchShebangs requires executable file
    patchShebangs meson_post_install.py
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      # Fix pages being blank
      # https://gitlab.gnome.org/GNOME/devhelp/issues/14
      --prefix XDG_DATA_DIRS : "${shared-mime-info}/share"
    )
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "devhelp";
      attrPath = "gnome3.devhelp";
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
