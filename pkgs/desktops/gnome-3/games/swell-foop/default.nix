{ stdenv, fetchurl, meson, ninja, pkgconfig, vala, glib, gtk3, gnome3, desktop-file-utils
, clutter, clutter-gtk, gettext, itstool, libxml2, wrapGAppsHook, python3 }:

let
  pname = "swell-foop";
  version = "3.34.1";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1032psxm59nissi268bh3j964m4a0n0ah4dy1pf0ph27j3zvdik1";
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
    homepage = "https://wiki.gnome.org/Apps/Swell%20Foop";
    description = "Puzzle game, previously known as Same GNOME";
    maintainers = teams.gnome.members;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
