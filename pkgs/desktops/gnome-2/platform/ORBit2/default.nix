{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  glib,
  libIDL,
  libintl,
  buildPackages,
}:

stdenv.mkDerivation rec {
  pname = "ORBit2";
  version = "2.14.19";

  src = fetchurl {
    url = "mirror://gnome/sources/ORBit2/${lib.versions.majorMinor version}/ORBit2-${version}.tar.bz2";
    sha256 = "0l3mhpyym9m5iz09fz0rgiqxl2ym6kpkwpsp1xrr4aa80nlh1jam";
  };

  strictDeps = true;

  patches = [ ./implicit-int.patch ];

  # Processing file orbit-interface.idl
  # sh: gcc: not found
  # output does not contain binaries for build
  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [
    pkg-config
    libintl
  ];
  propagatedBuildInputs = [
    glib
    libIDL
  ];

  outputs = [
    "out"
    "dev"
  ];

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals (stdenv.cc.isGNU && (lib.versionAtLeast (lib.getVersion stdenv.cc.cc) "14")) [
      # the ./configure script is not compatible with gcc-14, not easy to
      # regenerate without porting: https://github.com/NixOS/nixpkgs/issues/367694
      "-Wno-error=implicit-int"
      "-Wno-error=incompatible-pointer-types"
    ]
  );

  configureFlags = lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "--with-idl-compiler=${lib.getExe' buildPackages.gnome2.ORBit2 "orbit-idl-2"}"
    # https://github.com/void-linux/void-packages/blob/e5856e02aa6ef7e4f2725afbff2915f89d39024b/srcpkgs/ORBit2/template#L17-L35
    "ac_cv_alignof_CORBA_boolean=1"
    "ac_cv_alignof_CORBA_char=1"
    "ac_cv_alignof_CORBA_double=8"
    "ac_cv_alignof_CORBA_float=4"
    "ac_cv_alignof_CORBA_long=4"
    "ac_cv_alignof_CORBA_long_double=8"
    "ac_cv_alignof_CORBA_long_long=8"
    "ac_cv_alignof_CORBA_octet=1"
    "ac_cv_alignof_CORBA_short=2"
    "ac_cv_alignof_CORBA_struct=1"
    "ac_cv_alignof_CORBA_wchar=2"
    "ac_cv_alignof_CORBA_pointer=${if stdenv.hostPlatform.is64bit then "8" else "4"}"
  ];

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
    homepage = "https://developer-old.gnome.org/ORBit2/";
    description = "CORBA 2.4-compliant Object Request Broker";
    platforms = platforms.unix;
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
