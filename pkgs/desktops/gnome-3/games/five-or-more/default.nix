{ stdenv, fetchurl, meson, ninja, pkgconfig, gnome3, gtk3, wrapGAppsHook
, librsvg, libgnome-games-support, gettext, itstool, libxml2, python3, vala }:

stdenv.mkDerivation rec {
  pname = "five-or-more";
  version = "3.32.1";

  src = fetchurl {
    url = "mirror://gnome/sources/five-or-more/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0xw05dd2dwi9vsph9h158b4n89s5k07xrh6bjz1icm0pdmjwhpgk";
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
    homepage = "https://wiki.gnome.org/Apps/Five_or_more";
    description = "Remove colored balls from the board by forming lines";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
