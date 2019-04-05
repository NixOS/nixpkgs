{ stdenv, fetchurl, meson, ninja, pkgconfig, gnome3, gtk3, wrapGAppsHook
, librsvg, libgnome-games-support, gettext, itstool, libxml2, python3, vala }:

stdenv.mkDerivation rec {
  name = "five-or-more-${version}";
  version = "3.32.0";

  src = fetchurl {
    url = "mirror://gnome/sources/five-or-more/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0v52i22ygv6y4zqs8nyb1qmacmj9whhqrw7qss6vn7by4nsikhrn";
  };

  nativeBuildInputs = [
    meson ninja pkgconfig gettext itstool libxml2 python3 wrapGAppsHook
    vala
  ];
  buildInputs = [
    gtk3 librsvg libgnome-games-support gnome3.adwaita-icon-theme
  ];

  postPatch = ''
    chmod +x meson_post_install.py # patchShebangs requires executable file
    patchShebangs meson_post_install.py
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "five-or-more";
      attrPath = "gnome3.five-or-more";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Five_or_more;
    description = "Remove colored balls from the board by forming lines";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
