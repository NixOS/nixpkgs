{ stdenv, fetchurl, meson, ninja, pkgconfig, gnome3, gtk3, wrapGAppsHook
, glib, amtk, appstream-glib, gobjectIntrospection, python3
, webkitgtk, gettext, itstool, gsettings-desktop-schemas }:

stdenv.mkDerivation rec {
  name = "devhelp-${version}";
  version = "3.30.0";

  src = fetchurl {
    url = "mirror://gnome/sources/devhelp/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "1rzilsn0v8dj86djankllc5f10d58f6rwg4w1fffh5zly10nlli5";
  };

  nativeBuildInputs = [ meson ninja pkgconfig gettext itstool wrapGAppsHook appstream-glib gobjectIntrospection python3 ];
  buildInputs = [
    glib gtk3 webkitgtk amtk
    gnome3.defaultIconTheme gsettings-desktop-schemas
  ];

  doCheck = true;

  postPatch = ''
    chmod +x meson_post_install.py # patchShebangs requires executable file
    patchShebangs meson_post_install.py
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "devhelp";
      attrPath = "gnome3.devhelp";
    };
  };

  meta = with stdenv.lib; {
    description = "API documentation browser for GNOME";
    homepage = https://wiki.gnome.org/Apps/Devhelp;
    license = licenses.gpl2;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
