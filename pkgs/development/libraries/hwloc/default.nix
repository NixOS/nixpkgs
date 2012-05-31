{ stdenv, fetchurl, pkgconfig, cairo, expat, ncurses, libX11
, pciutils, numactl }:

stdenv.mkDerivation rec {
  name = "hwloc-1.4.2";

  src = fetchurl {
    url = "http://www.open-mpi.org/software/hwloc/v1.4/downloads/${name}.tar.bz2";
    sha256 = "0xamcnbkrf18v1rj4h6ddx6cn4gffx6zgzjaym8c3k5mlpgigfdw";
  };

  # XXX: libX11 is not directly needed, but needed as a propagated dep of Cairo.
  buildNativeInputs = [ pkgconfig ];

  # Filter out `null' inputs.  This allows users to `.override' the
  # derivation and set optional dependencies to `null'.
  buildInputs = stdenv.lib.filter (x: x != null)
   ([ expat ncurses ]
     ++  (stdenv.lib.optionals (!stdenv.isCygwin) [ cairo libX11 ])
     ++  (stdenv.lib.optionals stdenv.isLinux [ pciutils numactl ]));

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
