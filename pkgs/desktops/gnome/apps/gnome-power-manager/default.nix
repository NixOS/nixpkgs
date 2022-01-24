{ lib, stdenv
, gettext
, fetchurl
, pkg-config
, gtk3
, glib
, meson
, ninja
, upower
, python3
, desktop-file-utils
, wrapGAppsHook
, gnome }:

let
  pname = "gnome-power-manager";
  version = "3.32.0";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0drfn3wcc8l4n07qwv6p0rw2dwcd00hwzda282q62l6sasks2b2g";
  };

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "gnome.${pname}";
    };
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook
    gettext

    # needed by meson_post_install.sh
    python3
    glib.dev
    desktop-file-utils
  ];

  buildInputs = [
    gtk3
    glib
    upower
    gnome.adwaita-icon-theme
  ];

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-power-manager";
    description = "View battery and power statistics provided by UPower";
    maintainers = teams.gnome.members;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
