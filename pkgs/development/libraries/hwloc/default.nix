{ stdenv, fetchurl, pkgconfig, cairo, expat }:

stdenv.mkDerivation rec {
  name = "hwloc-0.9.2";

  src = fetchurl {
    url = "http://www.open-mpi.org/software/hwloc/v0.9/downloads/${name}.tar.bz2";
    sha256 = "1smxvz2g05kci1ra78iqmgk02rym3qwh1mrm68rxv70fhqhvq741";
  };

  buildInputs = [ pkgconfig cairo expat ];

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

    # It doesn't support the BSDs.
    platforms = stdenv.lib.platforms.linux
             ++ stdenv.lib.platforms.darwin
             ++ stdenv.lib.platforms.cygwin
             /* ++ opensolaris */;
  };
}
