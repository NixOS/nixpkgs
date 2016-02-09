{ stdenv, fetchurl, pkgconfig, intltool, gnome3 }:

stdenv.mkDerivation rec {
  name = "gnome-video-effects-${version}";
  version = "0.4.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-video-effects/0.4/${name}.tar.xz";
    sha256 = "0jl4iny2dqpcgi3sgxzpgnbw0752i8ay3rscp2cgdjlp79ql5gil";
  };

  buildInputs = [ pkgconfig intltool ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/GnomeVideoEffects;
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
  };
}
