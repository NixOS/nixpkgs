{ stdenv, fetchurl, glib, pkgconfig, gnome3, intltool
, gobjectIntrospection, makeWrapper }:

stdenv.mkDerivation rec {
  name = "nautilus-sendto-${version}";

  version = "3.8.1";

  src = fetchurl {
    url = "mirror://gnome/sources/nautilus-sendto/3.8/${name}.tar.xz";
    sha256 = "03fa46bff271acdbdedab6243b2a84e5ed3daa19c81b69d087b3e852c8fe5dab";
  };

  buildInputs = [ glib pkgconfig gobjectIntrospection intltool makeWrapper ];

  meta = with stdenv.lib; {
    description = "Integrates Evolution and Pidgin into the Nautilus file manager";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
