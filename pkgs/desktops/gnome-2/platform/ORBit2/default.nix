{ lib, stdenv, fetchurl, pkg-config, glib, libIDL, libintl }:

stdenv.mkDerivation rec {
  pname = "ORBit2";
  version = "2.14.19";

  src = fetchurl {
    url = "mirror://gnome/sources/ORBit2/${lib.versions.majorMinor version}/ORBit2-${version}.tar.bz2";
    sha256 = "0l3mhpyym9m5iz09fz0rgiqxl2ym6kpkwpsp1xrr4aa80nlh1jam";
  };

  nativeBuildInputs = [ pkg-config libintl ];
  propagatedBuildInputs = [ glib libIDL ];

  outputs = [ "out" "dev" ];

  preBuild = ''
    sed 's/-DG_DISABLE_DEPRECATED//' -i linc2/src/Makefile
  '';

  preFixup = ''
    moveToOutput "bin/orbit2-config" "$dev"
  '';

  # Parallel build fails due to missing internal library dependency:
  #    libtool --tag=CC   --mode=link gcc ... -o orbit-name-server-2 ...
  #    ld: cannot find libname-server-2.a: No such file or directory
  # It happens because orbit-name-server-2 should have libname-server-2.a
  # in _DEPENDENCIES but does not. Instead of fixing it and regenerating
  # Makefile.in let's just disable parallel build.
  enableParallelBuilding = false;

  meta = with lib; {
    homepage    = "https://developer-old.gnome.org/ORBit2/";
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
