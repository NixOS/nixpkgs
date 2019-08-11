{ stdenv
, gettext
, fetchurl
, pkgconfig
, gtk3
, glib
, meson
, ninja
, upower
, python3
, desktop-file-utils
, wrapGAppsHook
, gnome3 }:

let
  pname = "gnome-power-manager";
  version = "3.32.0";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0drfn3wcc8l4n07qwv6p0rw2dwcd00hwzda282q62l6sasks2b2g";
  };

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
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
    gnome3.adwaita-icon-theme
  ];

  meta = with stdenv.lib; {
    homepage = https://projects-old.gnome.org/gnome-power-manager/;
    description = "View battery and power statistics provided by UPower";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
