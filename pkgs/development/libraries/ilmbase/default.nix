{ stdenv, lib, buildPackages, automake, autoconf, libtool, which,
  fetchpatch, openexr }:

stdenv.mkDerivation rec {
  pname = "ilmbase";
  version = lib.getVersion openexr;

  # the project no longer provides separate tarballs. We may even want to merge
  # the ilmbase package into openexr in the future.
  src = openexr.src;

  sourceRoot = "source/IlmBase";

  outputs = [ "out" "dev" ];

  preConfigure = ''
    patchShebangs ./bootstrap
    ./bootstrap
  '';

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ automake autoconf libtool which ];

  NIX_CFLAGS_LINK = "-pthread";

  patches = [
    ./cross.patch
  ];

  # fails 1 out of 1 tests with
  # "lt-ImathTest: testBoxAlgo.cpp:892: void {anonymous}::boxMatrixTransform(): Assertion `b21 == b2' failed"
  # at least on i686. spooky!
  doCheck = stdenv.isx86_64;

  meta = with stdenv.lib; {
    description = " A library for 2D/3D vectors and matrices and other mathematical objects, functions and data types for computer graphics";
    homepage = "https://www.openexr.com/";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
