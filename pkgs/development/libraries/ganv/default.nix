{ stdenv, fetchgit, graphviz, gtk2, gtkmm2, pkgconfig, python, wafHook }:

stdenv.mkDerivation rec {
  name = "ganv-unstable-${rev}";
  rev = "2016-10-15";

  src = fetchgit {
    url = "http://git.drobilla.net/cgit.cgi/ganv.git";
    rev = "31685d283e9b811b61014f820c42807f4effa071";
    sha256 = "0xmbykdl42jn9cgzrqrys5lng67d26nk5xq10wkkvjqldiwdck56";
  };

  nativeBuildInputs = [ pkgconfig wafHook ];
  buildInputs = [ graphviz gtk2 gtkmm2 python ];

  meta = with stdenv.lib; {
    description = "An interactive Gtk canvas widget for graph-based interfaces";
    homepage = http://drobilla.net;
    license = licenses.gpl3;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
