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
  version = "3.30.0";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0m15x6i279wrfimz9ma2gfjv7jlkca2qbl2wcnxgx1pb3hzrwggm";
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
    gnome3.defaultIconTheme
  ];

  meta = with stdenv.lib; {
    homepage = https://projects-old.gnome.org/gnome-power-manager/;
    description = "View battery and power statistics provided by UPower";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
