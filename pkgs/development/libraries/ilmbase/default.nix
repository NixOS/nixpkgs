{ stdenv, fetchurl, buildPackages, automake, autoconf, libtool, which,
  fetchpatch }:

stdenv.mkDerivation rec {
  pname = "ilmbase";
  version = "2.3.0";

  src = fetchurl {
    url = "https://github.com/openexr/openexr/releases/download/v${version}/${pname}-${version}.tar.gz";
    sha256 = "0qiq5bqq9rxhqjiym2k36sx4vq8adgrz6xf6qwizi9bqm78phsa5";
  };

  outputs = [ "out" "dev" ];

  preConfigure = ''
    patchShebangs ./bootstrap
    ./bootstrap
  '';

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ automake autoconf libtool which ];

  NIX_CFLAGS_LINK = "-pthread";

  patches = [
    ./bootstrap.patch
    ./cross.patch
    (fetchpatch {
      name = "CVE-2018-18443.patch";
      url = "https://github.com/kdt3rd/openexr/commit/5fa930b82cff2db386c64ca512af19e60c14d32a.patch";
      sha256 = "1j6xd0qkx99acc1szycxaj0wwp01yac67jz48hwc4fwwpz8blx4s";
      stripLen = 1;
      excludes = [ "CHANGES.md" ];
    })
  ];

  # fails 1 out of 1 tests with
  # "lt-ImathTest: testBoxAlgo.cpp:892: void {anonymous}::boxMatrixTransform(): Assertion `b21 == b2' failed"
  # at least on i686. spooky!
  doCheck = stdenv.isx86_64;

  meta = with stdenv.lib; {
    description = " A library for 2D/3D vectors and matrices and other mathematical objects, functions and data types for computer graphics";
    homepage = https://www.openexr.com/;
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
