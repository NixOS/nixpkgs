{ stdenv, fetchurl, meson, ninja, pkgconfig, vala, glib, gtk3, gnome3, desktop-file-utils
, clutter, clutter-gtk, gettext, itstool, libxml2, wrapGAppsHook }:

let
  pname = "swell-foop";
  version = "3.28.0";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "1yjmg6sgi7mvp10fsqlkqshajmh8kgdmg6vyj5r8y48pv2ihfk64";
  };

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  nativeBuildInputs = [ meson ninja vala pkgconfig wrapGAppsHook itstool gettext libxml2 desktop-file-utils ];
  buildInputs = [ glib gtk3 gnome3.defaultIconTheme clutter clutter-gtk ];

  postPatch = ''
    chmod +x meson_post_install.py # patchShebangs requires executable file
    patchShebangs meson_post_install.py
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Swell%20Foop;
    description = "Puzzle game, previously known as Same GNOME";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
