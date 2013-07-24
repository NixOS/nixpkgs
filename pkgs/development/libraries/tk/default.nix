{ stdenv, fetchurl, tcl, x11, libX11 }:

stdenv.mkDerivation {
  name = "tk-8.5.7";
  
  src = fetchurl {
    url = "mirror://sourceforge/tcl/tk8.5.7-src.tar.gz";
    sha256 = "0c5gsy3nlwl0wn9swz4k4v7phy7nzjl317gca1jykgf4jz9nwdnr";
  };
  
  postInstall = ''
    ln -s $out/bin/wish* $out/bin/wish
  '';
  
  configureFlags = "--with-tcl=${tcl}/lib";
  
  preConfigure = "cd unix";

  buildInputs = [ tcl x11 libX11 ];
  
  inherit tcl;

  passthru = {
    libPrefix = "tk8.5";
  };

  meta = {
    description = "A widget toolkit that provides a library of basic elements for building a GUI in many different programming languages";
    homepage = http://www.tcl.tk/;
    maintainers = with stdenv.lib.maintainers; [ lovek323 ];
    platforms = stdenv.lib.platforms.all;
  };
}
