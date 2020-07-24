{ stdenv, fetchurl, meson, ninja, pkgconfig, wrapGAppsHook, python3
, gettext, gnome3, glib, gtk3, libgnome-games-support, gdk-pixbuf }:

let
  pname = "atomix";
  version = "3.34.0";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0h909a4mccf160hi0aimyicqhq2b0gk1dmqp7qwf87qghfrw6m00";
  };

  nativeBuildInputs = [ meson ninja pkgconfig gettext wrapGAppsHook python3 ];
  buildInputs = [ glib gtk3 gdk-pixbuf libgnome-games-support gnome3.adwaita-icon-theme ];

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    description = "Puzzle game where you move atoms to build a molecule";
    homepage = "https://wiki.gnome.org/Apps/Atomix";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
