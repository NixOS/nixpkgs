{ stdenv, fetchurl, meson, ninja, pkgconfig, wrapGAppsHook, python3
, gettext, gnome3, glib, gtk3, libgnome-games-support, gdk_pixbuf }:

let
  pname = "atomix";
  version = "3.30.0.1";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0hvr36m8ixa172zblv29fga1cn9yb84zqbisb21msfkwia2pabw3";
  };

  nativeBuildInputs = [ meson ninja pkgconfig gettext wrapGAppsHook python3 ];
  buildInputs = [ glib gtk3 gdk_pixbuf libgnome-games-support gnome3.defaultIconTheme ];

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
    homepage = https://wiki.gnome.org/Apps/Atomix;
    license = licenses.gpl2Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
