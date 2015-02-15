{ stdenv, fetchgit, pkgconfig, autoreconfHook, librep, gtk2 }:

with stdenv.lib;
stdenv.mkDerivation rec {

  name = "rep-gtk-git-2015-02-15";

  src = fetchgit {
    url = "https://github.com/SawfishWM/rep-gtk.git";
    rev = "74ac3504f2bbbcc9ded005ab97cbf94cdc47924d";
    sha256 = "edb47c5b6d09201d16a8f0616d18690ff0a37dca56d31c6e635b286bd0b6a031";
  };

  buildInputs = [ pkgconfig autoreconfHook ];
  propagatedBuildInputs = [ librep gtk2 ];

  patchPhase = ''
    sed -e 's|installdir=$(repexecdir)|installdir=$(libdir)/rep|g' -i Makefile.in
  '';

  meta = {
    description = "GTK+ bindings for librep";
    homepage = http://sawfish.wikia.com;
    license = licenses.gpl2;
    maintainers = [ maintainers.AndersonTorres ];
  };
}
