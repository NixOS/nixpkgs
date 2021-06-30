{ lib, stdenv, fetchurl, writeText, tcl }:

tcl.mkTclDerivation rec {
  pname = "incrtcl";
  version = "4.2.0";

  src = fetchurl {
    url    = "mirror://sourceforge/incrtcl/%5BIncr%20Tcl_Tk%5D-source/3.4/itcl${version}.tar.gz";
    sha256 = "0w28v0zaraxcq1s9pa6cihqqwqvvwfgz275lks7w4gl7hxjxmasw";
  };

  enableParallelBuilding = true;

  patchPhase = ''
    substituteInPlace configure --replace "\''${TCL_SRC_DIR}/generic" "${tcl}/include"
  '';

  postInstall = ''
    rmdir $out/bin
    mv $out/lib/itcl${version}/* $out/lib
    ln -s libitcl${version}${stdenv.hostPlatform.extensions.sharedLibrary} \
      $out/lib/libitcl${lib.versions.major version}${stdenv.hostPlatform.extensions.sharedLibrary}
    rmdir $out/lib/itcl${version}
  '';

  setupHook = writeText "setup-hook.sh" ''
    export ITCL_LIBRARY=@out@/lib
  '';

  outputs = [ "out" "dev" "man" ];

  meta = with lib; {
    homepage    = "http://incrtcl.sourceforge.net/";
    description = "Object Oriented Enhancements for Tcl/Tk";
    license     = licenses.tcltk;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
