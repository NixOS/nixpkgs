{ fetchurl, stdenv, gmpxx, perl, gnum4 }:

let version = "0.10.2"; in
  stdenv.mkDerivation rec {
    name = "ppl-${version}";

    src = fetchurl {
      url = "ftp://ftp.cs.unipr.it/pub/ppl/releases/${version}/${name}.tar.bz2";
      sha256 = "0xz2f3lny4l9ji1ilg6pxv34sh4cbh535cnm68smynzp01wgnh7y";
    };

    buildInputs = [ perl gnum4 ];
    propagatedBuildInputs = [ gmpxx ];

    # Beware!  It took ~6 hours to compile PPL and run its tests on a 1.2 GHz
    # x86_64 box.  Nevertheless, being a dependency of GCC, it probably ought
    # to be tested.
    doCheck = false;

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

      homepage = http://www.cs.unipr.it/ppl/;

      license = "GPLv3+";

      maintainers = [ stdenv.lib.maintainers.ludo ];
    };
  }
