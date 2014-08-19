{ stdenv, fetchurl, cmake, automoc4, qt4, pulseaudio }:

let
  v = "4.7.1";
in

stdenv.mkDerivation rec {
  name = "phonon-${v}";

  src = fetchurl {
    url = "mirror://kde/stable/phonon/${v}/${name}.tar.xz";
    sha256 = "0pdpj7xnalr511zx12akxg6smz7x5gybkpliclb5f5dcxqnq1xsg";
  };

  buildInputs = [ qt4 pulseaudio ];

  nativeBuildInputs = [ cmake automoc4 ];

  meta = {
    homepage = http://phonon.kde.org/;
    description = "Multimedia API for Qt";
    license = stdenv.lib.licenses.lgpl2;
    platforms = stdenv.lib.platforms.linux;
  };  
}
