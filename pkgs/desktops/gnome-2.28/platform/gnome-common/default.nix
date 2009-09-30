{stdenv, fetchgit, pkgconfig, autoconf, automake, libtool}:

stdenv.mkDerivation {
  name = "gnome-common-2.28.0";
  src =  fetchgit {
    url = mirror://gnome/sources/gnome-common/2.28/gnome-common-2.28.0.tar.bz2;
    sha256 = "18dnx5hndl19lpk6i3ybfsssfasma5wi7p9mqw05sx137l81fj6x";
  };
  buildInputs = [ pkgconfig automake autoconf libtool
    ];
  preConfigure = ''
    ./autogen.sh
  '';
}
