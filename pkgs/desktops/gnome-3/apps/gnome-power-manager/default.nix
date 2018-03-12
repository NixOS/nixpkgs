{ stdenv
, intltool
, fetchurl
, pkgconfig
, gtk3
, glib
, meson
, ninja
, upower
, desktop-file-utils
, wrapGAppsHook
, gnome3 }:

stdenv.mkDerivation rec {
  name = "gnome-power-manager-${version}";
  version = "3.26.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-power-manager/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "20aee0b0b4015e7cc6fbabc3cbc4344c07c230fe3d195e90c8ae0dc5d55a2d4e";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-power-manager"; attrPath = "gnome3.gnome-power-manager"; };
  };

  propagatedUserEnvPkgs = [ gnome3.gnome-themes-standard ];

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    wrapGAppsHook
    intltool

    # needed by meson_post_install.sh
    glib.dev
    desktop-file-utils
  ];

  buildInputs = [
    gtk3
    glib
    upower
    gnome3.defaultIconTheme
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://projects.gnome.org/gnome-power-manager/;
    description = "View battery and power statistics provided by UPower";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
