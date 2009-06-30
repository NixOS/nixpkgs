{stdenv, fetchurl, intltool}:

stdenv.mkDerivation {
  name = "gnome-mime-data-2.18.0";
  src = fetchurl {
    url = mirror://gnome/platform/2.26/2.26.2/sources/gnome-mime-data-2.18.0.tar.bz2;
    sha256 = "1mvg8glb2a40yilmyabmb7fkbzlqd3i3d31kbkabqnq86xdnn69p";
  };
  buildInputs = [ intltool ];
}
