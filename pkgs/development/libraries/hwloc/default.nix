{ lib, stdenv, fetchurl, pkg-config, expat, ncurses, pciutils, numactl
, x11Support ? false
, libX11
, cairo
, config
, enableCuda ? config.cudaSupport
, cudaPackages
}:

stdenv.mkDerivation rec {
  pname = "hwloc";
  version = "2.10.0";

  src = fetchurl {
    url = "https://www.open-mpi.org/software/hwloc/v${lib.versions.majorMinor version}/downloads/hwloc-${version}.tar.bz2";
    sha256 = "sha256-AwXdYMneL75lGf4qTo/cbT243ldKDKeBK5LoDAWuE5I=";
  };

  configureFlags = [
    "--localstatedir=/var"
    "--enable-netloc"
  ];

  # XXX: libX11 is not directly needed, but needed as a propagated dep of Cairo.
  nativeBuildInputs = [ pkg-config ]
  ++ lib.optionals enableCuda [ cudaPackages.cuda_nvcc ];

  buildInputs = [ expat ncurses ]
    ++ lib.optionals x11Support [ cairo libX11 ]
    ++ lib.optionals stdenv.isLinux [ numactl ]
    ++ lib.optionals enableCuda [ cudaPackages.cuda_cudart ];

  # Since `libpci' appears in `hwloc.pc', it must be propagated.
  propagatedBuildInputs = lib.optional stdenv.isLinux pciutils;

  enableParallelBuilding = true;

  postInstall = lib.optionalString stdenv.isLinux ''
    if [ -d "${numactl}/lib64" ]; then
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

  meta = with lib; {
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
    # https://www.open-mpi.org/projects/hwloc/license.php
    license = licenses.bsd3;
    homepage = "https://www.open-mpi.org/projects/hwloc/";
    maintainers = with maintainers; [ fpletz markuskowa ];
    platforms = platforms.all;
  };
}
