{ stdenv, fetchurl, pkgconfig, glib, libcanberra_gtk2, gobjectIntrospection, libtool, gnome3 }:

let
  majVer = "1.0";
in stdenv.mkDerivation rec {
  name = "gsound-${majVer}.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gsound/${majVer}/${name}.tar.xz";
    sha256 = "bba8ff30eea815037e53bee727bbd5f0b6a2e74d452a7711b819a7c444e78e53";
  };

  nativeBuildInputs = [ pkgconfig gobjectIntrospection libtool gnome3.vala ];
  buildInputs = [ glib libcanberra_gtk2 ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/GSound;
    description = "Small library for playing system sounds";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
