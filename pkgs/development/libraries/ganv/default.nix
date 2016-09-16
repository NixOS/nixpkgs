{ stdenv, fetchsvn, graphviz, gtkmm2, pkgconfig, python }:

stdenv.mkDerivation rec {
  name = "ganv-svn-${rev}";
  rev = "5675";

  src = fetchsvn {
    url = "http://svn.drobilla.net/lad/trunk/ganv";
    rev = rev;
    sha256 = "0klzng3jvc09lj4hxnzlb8z5s5qp8rj16b1x1j6hcbqdja54fccj";
  };

  buildInputs = [ graphviz gtkmm2 pkgconfig python ];

  configurePhase = "python waf configure --prefix=$out";

  buildPhase = "python waf";

  installPhase = "python waf install";

  meta = with stdenv.lib; {
    description = "An interactive Gtk canvas widget for graph-based interfaces";
    homepage = http://drobilla.net;
    license = licenses.gpl3;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
