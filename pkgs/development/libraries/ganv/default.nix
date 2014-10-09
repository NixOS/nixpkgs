{ stdenv, fetchurl, graphviz, gtk, gtkmm, pkgconfig, python }:

stdenv.mkDerivation rec {
  name = "ganv-${version}";
  version = "1.4.2";

  src = fetchurl {
    url = "http://download.drobilla.net/${name}.tar.bz2";
    sha256 = "0g7s5mp14qgbfjdql0k1s8464r21g47ssn5dws6jazsnw6njhl0l";
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
