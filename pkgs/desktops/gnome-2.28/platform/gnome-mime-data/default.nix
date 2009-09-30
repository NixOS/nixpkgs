{stdenv, fetchurl, intltool}:

stdenv.mkDerivation {
  name = "gnome-mime-data-2.18.0";
  src = fetchurl {
    url = mirror:/gnome/sources/gnome-mime-data/2.18/gnome-mime-data-2.18.0.tar.bz2;
    sha256 = "1mvg8glb2a40yilmyabmb7fkbzlqd3i3d31kbkabqnq86xdnn69p"
  };
  buildInputs = [ intltool ];
}
