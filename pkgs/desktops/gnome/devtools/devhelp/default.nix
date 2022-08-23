{ stdenv
, lib
, fetchurl
, fetchpatch
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
, webkitgtk
, gettext
, itstool
, gsettings-desktop-schemas
, shared-mime-info
}:

stdenv.mkDerivation rec {
  pname = "devhelp";
  version = "41.2";

  outputs = [ "out" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/devhelp/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "7KqQsPTaqPsgMPbcaQv1M/+Zp3NDf+Dhis/oLZl/YNI=";
  };

  patches = [
    # Fix build with meson 0.61
    # https://gitlab.gnome.org/GNOME/devhelp/-/issues/59
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/devhelp/-/commit/281bade14c1925cf9e7329fa8e9cf2d82512c66f.patch";
      sha256 = "LmHoeQ0zJwOhuasAUYy8FfpDnEO+UNfEb293uKttYKo=";
    })
  ];

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
    webkitgtk
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
