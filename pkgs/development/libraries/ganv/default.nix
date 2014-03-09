{ stdenv, fetchsvn, graphviz, gtk, gtkmm, pkgconfig, python }:

stdenv.mkDerivation rec {
  name = "ganv-svn-${rev}";
  rev = "5318";

  src = fetchsvn {
    url = "http://svn.drobilla.net/lad/trunk/ganv";
    rev = rev;
    sha256 = "0wi87ks2xjma979d9hy82wmlm06g4sr0pm3b1n3zv27y52wrf7fl";
  };

  buildInputs = [ graphviz gtk gtkmm pkgconfig python ];

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
