{
  stdenv,
  lib,
  buildPackages,
  cmake,
  openexr,
}:

stdenv.mkDerivation rec {
  pname = "ilmbase";
  version = lib.getVersion openexr;

  # the project no longer provides separate tarballs. We may even want to merge
  # the ilmbase package into openexr in the future.
  inherit (openexr) src patches;

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [ cmake ];
  depsBuildBuild = [ buildPackages.stdenv.cc ];

  # fails 1 out of 1 tests with
  # "lt-ImathTest: testBoxAlgo.cpp:892: void {anonymous}::boxMatrixTransform(): Assertion `b21 == b2' failed"
  # at least on i686. spooky!
  doCheck = stdenv.isx86_64;

  preConfigure = ''
    # Need to cd after patches for openexr patches to apply.
    cd IlmBase
  '';

  meta = with lib; {
    description = " A library for 2D/3D vectors and matrices and other mathematical objects, functions and data types for computer graphics";
    homepage = "https://www.openexr.com/";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
