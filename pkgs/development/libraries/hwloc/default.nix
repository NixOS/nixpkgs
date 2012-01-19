{ stdenv, fetchurl, pkgconfig, cairo, expat, ncurses, libX11 }:

stdenv.mkDerivation rec {
  name = "hwloc-1.3";

  src = fetchurl {
    url = "http://www.open-mpi.org/software/hwloc/v1.3/downloads/${name}.tar.bz2";
    sha256 = "10zlz0hng7scjx1xn8jflx3gbga5djbhxhj94k5kszrivc8zh8xy";
  };

  # XXX: libX11 is not directly needed, but needed as a propagated dep of Cairo.
  buildNativeInputs = [ pkgconfig ];

  # Filter out `null' inputs.  This allows users to `.override' the
  # derivation and set optional dependencies to `null'.
  buildInputs = stdenv.lib.filter (x: x != null)
   [ cairo expat ncurses libX11 ];

  doCheck = true;

  meta = {
    description = "hwloc, a portable abstraction of hierarchical architectures for high-performance computing";

    longDescription = ''
       hwloc provides a portable abstraction (across OS,
       versions, architectures, ...) of the hierarchical topology of
       modern architectures, including NUMA memory nodes, sockets,
       shared caches, cores and simultaneous multithreading.  It also
       gathers various attributes such as cache and memory
       information.  It primarily aims at helping high-performance
       computing applications with gathering information about the
       hardware so as to exploit it accordingly and efficiently.

       hwloc may display the topology in multiple convenient
       formats.  It also offers a powerful programming interface to
       gather information about the hardware, bind processes, and much
       more.
    '';

    # http://www.open-mpi.org/projects/hwloc/license.php
    license = "revised-BSD";

    homepage = http://www.open-mpi.org/projects/hwloc/;

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.all;
  };
}
