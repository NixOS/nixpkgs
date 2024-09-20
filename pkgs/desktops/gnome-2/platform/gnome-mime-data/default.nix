{ lib, stdenv, fetchurl, intltool }:

stdenv.mkDerivation rec {
  pname = "gnome-mime-data";
  version = "2.18.0";
  src = fetchurl {
    url = "mirror://gnome/sources/gnome-mime-data/${lib.versions.majorMinor version}/gnome-mime-data-${version}.tar.bz2";
    sha256 = "1mvg8glb2a40yilmyabmb7fkbzlqd3i3d31kbkabqnq86xdnn69p";
  };
  nativeBuildInputs = [ intltool ];
}
