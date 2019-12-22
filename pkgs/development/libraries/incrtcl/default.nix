{stdenv, fetchurl, tcl}:

stdenv.mkDerivation {
  pname = "incrtcl";
  version = "4.2.0";

  src = fetchurl {
    url = mirror://sourceforge/incrtcl/%5BIncr%20Tcl_Tk%5D-source/3.4/itcl4.2.0.tar.gz;
    sha256 = "0w28v0zaraxcq1s9pa6cihqqwqvvwfgz275lks7w4gl7hxjxmasw";
  };

  buildInputs = [ tcl ];
  configureFlags = [ "--with-tcl=${tcl}/lib" ];
  patchPhase = ''
      substituteInPlace configure --replace "\''${TCL_SRC_DIR}/generic" "${tcl}/include"
  '';
  preConfigure = ''
      configureFlags="--exec_prefix=$prefix $configureFlags"
  '';

  passthru = {
    libPrefix = "itcl3.4";
  };

  meta = with stdenv.lib; {
    homepage = http://incrtcl.sourceforge.net/;
    description = "Object Oriented Enhancements for Tcl/Tk";
    platforms = platforms.unix;
    license = licenses.tcltk;
  };
}
