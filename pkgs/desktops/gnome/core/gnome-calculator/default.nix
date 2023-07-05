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
, gtk4
, glib
, gtksourceview5
, wrapGAppsHook4
, gobject-introspection
, gnome
, mpfr
, gmp
, libsoup_3
, libmpc
, libadwaita
, gsettings-desktop-schemas
, libgee
}:

stdenv.mkDerivation rec {
  pname = "gnome-calculator";
  version = "44.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-calculator/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "FOdjMp+IMJp+FSeA1XNhtUMQDjI5BrNOBlX9wxW3EEM=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    gettext
    itstool
    wrapGAppsHook4
    gobject-introspection # for finding vapi files
  ];

  buildInputs = [
    gtk4
    glib
    libxml2
    gtksourceview5
    mpfr
    gmp
    libgee
    gsettings-desktop-schemas
    libsoup_3
    libmpc
    libadwaita
  ];

  doCheck = true;

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
    platforms = platforms.unix;
  };
}
