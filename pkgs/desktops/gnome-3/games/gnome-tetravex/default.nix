{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, libxml2, gettext, itstool, meson, ninja, python3
, vala, desktop-file-utils
}:

stdenv.mkDerivation rec {
  name = "gnome-tetravex-${version}";
  version = "3.32.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-tetravex/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "18drxp43j2jnywxl6qa7mn1iv33jxr0dpc1l9xza3lnrb0jp0kjl";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-tetravex"; attrPath = "gnome3.gnome-tetravex"; };
  };

  nativeBuildInputs = [
    wrapGAppsHook itstool libxml2 gnome3.adwaita-icon-theme
    pkgconfig gettext meson ninja python3 vala desktop-file-utils
  ];
  buildInputs = [
    gtk3
  ];

  postPatch = ''
    chmod +x build-aux/meson_post_install.py
    patchShebangs build-aux/meson_post_install.py
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Tetravex;
    description = "Complete the puzzle by matching numbered tiles";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
