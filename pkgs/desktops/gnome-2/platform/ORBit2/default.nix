{ stdenv, fetchurlGnome, pkgconfig, glib, libIDL, libintlOrEmpty }:

stdenv.mkDerivation rec {
  name = src.pkgname;
  
  src = fetchurlGnome {
    project = "ORBit2";
    major = "2"; minor = "14"; patchlevel = "19";
    sha256 = "0l3mhpyym9m5iz09fz0rgiqxl2ym6kpkwpsp1xrr4aa80nlh1jam";
  };

  preBuild = ''
    sed 's/-DG_DISABLE_DEPRECATED//' -i linc2/src/Makefile
  '';

  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ glib libIDL ] ++ libintlOrEmpty;

  meta = with stdenv.lib; {
    homepage    = https://projects.gnome.org/ORBit2/;
    description = "A a CORBA 2.4-compliant Object Request Broker";
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
