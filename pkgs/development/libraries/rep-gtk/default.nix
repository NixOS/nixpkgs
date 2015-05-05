{ stdenv, fetchurl, pkgconfig, autoreconfHook, librep, gtk2 }:

with stdenv.lib;
stdenv.mkDerivation rec {

  name = "rep-gtk-${version}";
  version = "0.90.8.2";

  src = fetchurl {
    url = "https://github.com/SawfishWM/rep-gtk/archive/${name}.tar.gz";
    sha256 = "0pkpp7pj22c8hkyyivr9qw6q08ad42alynsf54ixdy6p9wn4qs1r";
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
