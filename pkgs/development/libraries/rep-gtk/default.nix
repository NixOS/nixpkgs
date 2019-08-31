{ stdenv, fetchurl, pkgconfig, autoreconfHook, librep, gtk2 }:

with stdenv.lib;
stdenv.mkDerivation rec {

  pname = "rep-gtk";
  version = "0.90.8.3";
  sourceName = "rep-gtk_${version}";

  src = fetchurl {
    url = "https://download.tuxfamily.org/librep/rep-gtk/${sourceName}.tar.xz";
    sha256 = "0hgkkywm8zczir3lqr727bn7ybgg71x9cwj1av8fykkr8pdpard9";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ ];
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
# TODO: investigate fetchFromGithub
