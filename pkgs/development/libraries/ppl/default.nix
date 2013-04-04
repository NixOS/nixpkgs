{ fetchurl, stdenv, gmpxx, perl, gnum4 }:

let version = "1.0"; in

stdenv.mkDerivation rec {
  name = "ppl-${version}";

  src = fetchurl {
    url = "http://bugseng.com/products/ppl/download/ftp/releases/${version}/ppl-${version}.tar.bz2";
    sha256 = "0m0b6dzablci8mlavpsmn5w1v3r46li0wpjwvsybgxx0p1ifjsf1";
  };

  nativeBuildInputs = [ perl gnum4 ];
  propagatedBuildInputs = [ gmpxx ];

  configureFlags = "--disable-watchdog";

  patches = [ ./upstream-based.patch ];

  # Beware!  It took ~6 hours to compile PPL and run its tests on a 1.2 GHz
  # x86_64 box.  Nevertheless, being a dependency of GCC, it probably ought
  # to be tested.
  doCheck = false;

  enableParallelBuilding = true;

  meta = {
    description = "PPL: The Parma Polyhedra Library";

    longDescription = ''
      The Parma Polyhedra Library (PPL) provides numerical abstractions
      especially targeted at applications in the field of analysis and
      verification of complex systems.  These abstractions include convex
      polyhedra, defined as the intersection of a finite number of (open or
      closed) halfspaces, each described by a linear inequality (strict or
      non-strict) with rational coefficients; some special classes of
      polyhedra shapes that offer interesting complexity/precision tradeoffs;
      and grids which represent regularly spaced points that satisfy a set of
      linear congruence relations.  The library also supports finite
      powersets and products of (any kind of) polyhedra and grids and a mixed
      integer linear programming problem solver using an exact-arithmetic
      version of the simplex algorithm.
    '';

    homepage = http://bugseng.com/products/ppl/;

    license = "GPLv3+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
