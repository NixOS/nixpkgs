{ stdenv, fetchurl, meson, ninja, pkgconfig, vala, glib, gtk3, gnome3, desktop-file-utils
, clutter, clutter-gtk, gettext, itstool, libxml2, wrapGAppsHook, python3 }:

let
  pname = "swell-foop";
  version = "3.32.0";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0jpci3c1wyzbvsq86j30rcl166skhi2wf12001amfgh0dmmwipci";
  };

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  nativeBuildInputs = [ meson ninja vala pkgconfig wrapGAppsHook python3 itstool gettext libxml2 desktop-file-utils ];
  buildInputs = [ glib gtk3 gnome3.adwaita-icon-theme clutter clutter-gtk ];

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
