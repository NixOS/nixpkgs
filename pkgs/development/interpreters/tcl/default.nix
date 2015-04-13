{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "tcl-8.6.4";

  src = fetchurl {
    url = mirror://sourceforge/tcl/tcl8.6.4-src.tar.gz;
    sha256 = "13cwa4bc85ylf5gfj9vk182lvgy60qni3f7gbxghq78wk16djvly";
  };

  preConfigure = "cd unix";

  postInstall = ''
    make install-private-headers
    ln -s $out/bin/tclsh8.6 $out/bin/tclsh
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
