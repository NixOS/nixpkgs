{ stdenv
, lib
, meson
, ninja
, vala
, gettext
, itstool
, fetchurl
, pkg-config
, libxml2
, gtk3
, glib
, gtksourceview4
, wrapGAppsHook
, gobject-introspection
, python3
, gnome
, mpfr
, gmp
, libsoup
, libmpc
, libhandy
, gsettings-desktop-schemas
, libgee
}:

stdenv.mkDerivation rec {
  pname = "gnome-calculator";
  version = "40.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-calculator/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "1xkazxbkpn1z5pfphhps7fc5q4yc8lp7f6b222n8bx5iyxhwbrkz";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    gettext
    itstool
    wrapGAppsHook
    python3
    gobject-introspection # for finding vapi files
  ];

  buildInputs = [
    gtk3
    glib
    libxml2
    gtksourceview4
    mpfr
    gmp
    gnome.adwaita-icon-theme
    libgee
    gsettings-desktop-schemas
    libsoup
    libmpc
    libhandy
  ];

  doCheck = true;

  postPatch = ''
    chmod +x meson_post_install.py # patchShebangs requires executable file
    patchShebangs meson_post_install.py
  '';

  preCheck = ''
    # Currency conversion test tries to store currency data in $HOME/.cache.
    export HOME=$TMPDIR
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-calculator";
      attrPath = "gnome.gnome-calculator";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Calculator";
    description = "Application that solves mathematical equations and is suitable as a default application in a Desktop environment";
    maintainers = teams.gnome.members;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
