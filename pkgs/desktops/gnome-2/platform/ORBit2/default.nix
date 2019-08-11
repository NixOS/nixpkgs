{ stdenv, fetchurl, pkgconfig, glib, libIDL, libintl }:

stdenv.mkDerivation rec {
  name = "ORBit2-${minVer}.19";
  minVer = "2.14";

  src = fetchurl {
    url = "mirror://gnome/sources/ORBit2/${minVer}/${name}.tar.bz2";
    sha256 = "0l3mhpyym9m5iz09fz0rgiqxl2ym6kpkwpsp1xrr4aa80nlh1jam";
  };

  nativeBuildInputs = [ pkgconfig libintl ];
  propagatedBuildInputs = [ glib libIDL ];

  outputs = [ "out" "dev" ];

  preBuild = ''
    sed 's/-DG_DISABLE_DEPRECATED//' -i linc2/src/Makefile
  '';

  preFixup = ''
    moveToOutput "bin/orbit2-config" "$dev"
  '';

  meta = with stdenv.lib; {
    homepage    = https://projects.gnome.org/ORBit2/;
    description = "A CORBA 2.4-compliant Object Request Broker";
    platforms   = platforms.unix;
    maintainers = with maintainers; [ lovek323 ];

    longDescription = ''
      ORBit2 is a CORBA 2.4-compliant Object Request Broker (ORB) featuring
      mature C, C++ and Python bindings. Bindings (in various degrees of
      completeness) are also available for Perl, Lisp, Pascal, Ruby, and TCL;
      others are in-progress. It supports POA, DII, DSI, TypeCode, Any, IR and
      IIOP. Optional features including INS and threading are available. ORBit2
      is engineered for the desktop workstation environment, with a focus on
      performance, low resource usage, and security. The core ORB is written in
      C, and runs under Linux, UNIX (BSD, Solaris, HP-UX, ...), and Windows.
      ORBit2 is developed and released as open source software under GPL/LGPL.
    '';
  };
}
