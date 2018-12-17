{ stdenv, fetchurl, pkgconfig, expat, ncurses, pciutils, numactl
, x11Support ? false, libX11 ? null, cairo ? null
}:

assert x11Support -> libX11 != null && cairo != null;

with stdenv.lib;

let
  version = "2.0.3";
  versmm = versions.major version + "." + versions.minor version;
  name = "hwloc-${version}";

in stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "http://www.open-mpi.org/software/hwloc/v${versmm}/downloads/${name}.tar.bz2";
    sha256 = "09f7ajak8wv5issr0hw72vs3jkldc7crcc7z5fd34sspkvrsm4z3";
  };

  configureFlags = [
    "--localstatedir=/var"
    "--enable-netloc"
  ];

  # XXX: libX11 is not directly needed, but needed as a propagated dep of Cairo.
  nativeBuildInputs = [ pkgconfig ];

  # Filter out `null' inputs.  This allows users to `.override' the
  # derivation and set optional dependencies to `null'.
  buildInputs = stdenv.lib.filter (x: x != null)
   ([ expat ncurses ]
     ++  (optionals x11Support [ cairo libX11 ])
     ++  (optionals stdenv.isLinux [ numactl ]));

  propagatedBuildInputs =
    # Since `libpci' appears in `hwloc.pc', it must be propagated.
    optional stdenv.isLinux pciutils;

  enableParallelBuilding = true;

  postInstall =
    optionalString (stdenv.isLinux && numactl != null)
      '' if [ -d "${numactl}/lib64" ]
         then
             numalibdir="${numactl}/lib64"
         else
             numalibdir="${numactl}/lib"
             test -d "$numalibdir"
         fi

         sed -i "$lib/lib/libhwloc.la" \
             -e "s|-lnuma|-L$numalibdir -lnuma|g"
      '';

  # Checks disabled because they're impure (hardware dependent) and
  # fail on some build machines.
  doCheck = false;

  outputs = [ "out" "lib" "dev" "doc" "man" ];

  meta = {
    description = "Portable abstraction of hierarchical architectures for high-performance computing";
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
    license = licenses.bsd3;
    homepage = https://www.open-mpi.org/projects/hwloc/;
    maintainers = with maintainers; [ fpletz markuskowa ];
    platforms = platforms.all;
  };
}
