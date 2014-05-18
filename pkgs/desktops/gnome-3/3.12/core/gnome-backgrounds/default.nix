{ stdenv, fetchurl, pkgconfig, intltool }:

stdenv.mkDerivation rec {
  name = "gnome-backgrounds-3.12.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-backgrounds/3.12/${name}.tar.xz";
    sha256 = "ac4d3e0fffc5991865ca748e728a1ab87f167400105250ce2195b03502427180";
  };

  nativeBuildInputs = [ pkgconfig intltool ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };
}
