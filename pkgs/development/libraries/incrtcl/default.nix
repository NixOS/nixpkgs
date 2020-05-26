{ stdenv, fetchurl, writeText, tcl }:

stdenv.mkDerivation rec {
  pname = "incrtcl";
  version = "4.2.0";

  src = fetchurl {
    url    = "mirror://sourceforge/incrtcl/%5BIncr%20Tcl_Tk%5D-source/3.4/itcl${version}.tar.gz";
    sha256 = "0w28v0zaraxcq1s9pa6cihqqwqvvwfgz275lks7w4gl7hxjxmasw";
  };

  buildInputs = [ tcl ];
  configureFlags = [ "--with-tcl=${tcl}/lib" ];
  enableParallelBuilding = true;

  patchPhase = ''
    substituteInPlace configure --replace "\''${TCL_SRC_DIR}/generic" "${tcl}/include"
  '';

  preConfigure = ''
    configureFlags="--exec_prefix=$prefix $configureFlags"
  '';

  postInstall = ''
    rmdir $out/bin
    mv $out/lib/itcl${version}/* $out/lib
    rmdir $out/lib/itcl${version}
  '';

  setupHook = writeText "setup-hook.sh" ''
    export ITCL_LIBRARY=@out@/lib
  '';

  outputs = [ "out" "dev" "man" ];

  meta = with stdenv.lib; {
    homepage    = "http://incrtcl.sourceforge.net/";
    description = "Object Oriented Enhancements for Tcl/Tk";
    license     = licenses.tcltk;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
