{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "tcl-8.5.15";

  src = fetchurl {
    url = mirror://sourceforge/tcl/tcl8.5.15-src.tar.gz;
    sha256 = "0kl8lbfwy4v4q4461wjmva95h0pgiprykislpw4nnpkrc7jalkpj";
  };

  preConfigure = "cd unix";

  postInstall = ''
    make install-private-headers
    ln -s $out/bin/tclsh8.5 $out/bin/tclsh
  '';
  
  meta = {
    description = "The Tcl scription language";
    homepage = http://www.tcl.tk/;
    license = stdenv.lib.licenses.tcltk;
  };
  
  passthru = {
    libdir = "lib/tcl8.5";
  };
}
