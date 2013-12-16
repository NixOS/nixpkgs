{stdenv, fetchurl, tcl}:

stdenv.mkDerivation rec {
  name = "incrtcl-${version}";
  version = "3.4.1";
  
  src = fetchurl {
    url = mirror://sourceforge/incrtcl/%5BIncr%20Tcl_Tk%5D-source/3.4/itcl3.4.1.tar.gz;
    sha256 = "0s457j9mn3c1wjj43iwy3zwhyz980jlyqn3s9487da9dwwn86c2k";
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

  meta = {
    homepage = http://incrtcl.sourceforge.net/;
    description = "Object Oriented Enhancements for Tcl/Tk";
  };
}
