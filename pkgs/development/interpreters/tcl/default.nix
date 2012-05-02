{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "tcl-8.5.7";

  src = fetchurl {
    url = mirror://sourceforge/tcl/tcl8.5.7-src.tar.gz;
    sha256 = "1wk67qq12bdbaqsi6cxwj6ra8nc8ph1na9rh808kfk6hm18qvlk7";
  };

  preConfigure = "cd unix";

  postInstall = ''
    make install-private-headers
    ln -s $out/bin/tclsh8.5 $out/bin/tclsh
  '';
  
  meta = {
    description = "The Tcl scription language";
    homepage = http://www.tcl.tk/;
  };
  
  passthru = {
    libdir = "lib/tcl8.5";
  };
}
