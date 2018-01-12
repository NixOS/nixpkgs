{ stdenv, fetchurl, pkgconfig, intltool, gnome3 }:

stdenv.mkDerivation rec {
  name = "gnome-video-effects-${version}";
  version = "0.4.3";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-video-effects/0.4/${name}.tar.xz";
    sha256 = "06c2f1kihyhawap1s3zg5w7q7fypsybkp7xry4hxkdz4mpsy0zjs";
  };

  nativeBuildInputs = [ pkgconfig intltool ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/GnomeVideoEffects;
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
  };
}
