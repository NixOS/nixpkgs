{stdenv, fetchurl, tcl}:

stdenv.mkDerivation rec {
  pname = "incrtcl";
  version = "4.0.4";

  src = fetchurl {
    url = mirror://sourceforge/incrtcl/%5BIncr%20Tcl_Tk%5D-source/3.4/itcl4.0.4.tar.gz;
    sha256 = "1ppc9b13cvmc6rp77k7dl2zb26xk0z30vxygmr4h1xr2r8w091k3";
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
