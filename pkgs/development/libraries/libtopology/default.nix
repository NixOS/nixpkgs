{ stdenv, fetchurl, pkgconfig, cairo }:

stdenv.mkDerivation rec {
  name = "libtopology-0.9";

  src = fetchurl {
    url = "http://gforge.inria.fr/frs/download.php/22596/${name}.tar.gz";
    sha256 = "0vxi4cpfv74zgb08k58jkv8xj0x2m7i2mf26smfpjlfpfjrj71y4";
  };

  buildInputs = [ pkgconfig cairo ];

  doCheck = true;

  meta = {
    description = "libtopology, a portable abstraction of hierarchical architectures for high-performance computing";

    longDescription = ''
       libtopology provides a portable abstraction (across OS,
       versions, architectures, ...) of the hierarchical topology of
       modern architectures, including NUMA memory nodes, sockets,
       shared caches, cores and simultaneous multithreading.  It also
       gathers various attributes such as cache and memory
       information.  It primarily aims at helping high-performance
       computing applications with gathering information about the
       hardware so as to exploit it accordingly and efficiently.

       libtopology may display the topology in multiple convenient
       formats.  It also offers a powerful programming interface to
       gather information about the hardware, bind processes, and much
       more.
    '';

    # See http://www.cecill.info/licences/Licence_CeCILL-B_V1-en.html .
    license = "CeCILL-B";

    homepage = http://runtime.bordeaux.inria.fr/libtopology/;

    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
