{ lib
, stdenv
, fetchurl
, fetchpatch
, meson
, ninja
, pkg-config
, vala
, glib
, gtk3
, libgnome-games-support
, gnome3
, desktop-file-utils
, clutter
, clutter-gtk
, gettext
, itstool
, libxml2
, wrapGAppsHook
, python3
}:

stdenv.mkDerivation rec {
  pname = "swell-foop";
  version = "40.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "1swvazfc2ydc52njfrxdd0ns2apb2k54dq8vlj81y1vlwcqhgw3p";
  };

  patches = [
    # Fix launching with desktop file
    # https://gitlab.gnome.org/GNOME/swell-foop/-/issues/22
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/swell-foop/commit/614239dbe0f82e8de836cc5780e971366e09f035.patch";
      sha256 = "GyIDJ/dG6A2T5Ls6LjCy9Che5KP3H2LAVOOzH+mlQsM=";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    vala
    pkg-config
    wrapGAppsHook
    python3
    itstool
    gettext
    libxml2
    desktop-file-utils
  ];

  buildInputs = [
    glib
    gtk3
    libgnome-games-support
    gnome3.adwaita-icon-theme
    clutter
    clutter-gtk
  ];

  postPatch = ''
    chmod +x meson_post_install.py # patchShebangs requires executable file
    patchShebangs meson_post_install.py
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Swell%20Foop";
    description = "Puzzle game, previously known as Same GNOME";
    maintainers = teams.gnome.members;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
