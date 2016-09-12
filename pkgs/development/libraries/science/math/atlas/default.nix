{ stdenv, fetchurl, gfortran, tolerateCpuTimingInaccuracy ? true, shared ? false
, cpuConfig ? if stdenv.isi686 then "-b 32 -A 12 -V 1" else "-b 64 -A 14 -V 384"
, cacheEdge ? "262144"
, threads ? "0"
, liblapack, withLapack
}:

# Atlas detects the CPU and optimizes its build accordingly. This is great when
# the code is run on the same machine that built the binary, but in case of a
# central build farm like Hydra, this feature is dangerous because the code may
# be generated utilizing fancy features that users who download the binary
# cannot execute.
#
# To avoid these issues, the build is configured using the 'cpuConfig'
# parameter. Upstream recommends these defaults for distributions:
#
#   | x86 CPU                                     | x86_64 CPU             |
#   |---------------------------------------------+------------------------|
#   | -b 32                                       | -b 64                  |
#   | -A 12  (x86x87)                             | -A 14 (x86SSE2)        |
#   | -V 1 (No SIMD)                              | -V 384 (SSE1 and SSE2) |
#
# These defaults should give consistent performance across machines.
# Performance will be substantially lower than an optimized build, but a build
# optimized for one machine will give even worse performance on others. If you
# are a serious user of Atlas (e.g., you write code that uses it) you should
# compile an optimized version for each of your machines.
#
# The parameter 'cacheEdge' sets the L2 cache per core (in bytes). Setting this
# parameter reduces build time because some tests to detect the L2 cache size
# will not be run. It will also reduce impurity; different build nodes on Hydra
# may have different L2 cache sizes, but fixing the L2 cache size should
# account for that. This also makes the performance of binary substitutes more
# consistent.
#
# The -V flags can change with each release as new instruction sets are added
# because upstream thinks it's a good idea to add entries at the start of an
# enum, rather than the end. If the build suddenly fails with messages about
# missing instruction sets, you may need to poke around in the source a bit.
#
# Upstream recommends the x86x87/x86SSE2 architectures for generic x86/x86_64
# for distribution builds. Additionally, we set 'cacheEdge' to reduce impurity.
# Otherwise, the cache parameters will be detected by timing which will be
# highly variable on Hydra.

let
  inherit (stdenv.lib) optional optionalString;
  version = "3.10.2";
in

stdenv.mkDerivation {
  name = "atlas${optionalString withLapack "-with-lapack"}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/math-atlas/atlas${version}.tar.bz2";
    sha256 = "0bqh4bdnjdyww4mcpg6kn0x7338mfqbdgysn97dzrwwb26di7ars";
  };

  buildInputs = [ gfortran ];

  # Atlas aborts the build if it detects that some kind of CPU frequency
  # scaling is active on the build machine because that feature offsets the
  # performance timings. We ignore that check, however, because with binaries
  # being pre-built on Hydra those timings aren't accurate for the local
  # machine in the first place.
  patches = optional tolerateCpuTimingInaccuracy ./disable-timing-accuracy-check.patch
    ++ optional stdenv.isDarwin ./tmpdir.patch;

  hardeningDisable = [ "format" ];

  # Configure outside of the source directory.
  preConfigure = ''
    mkdir build
    cd build
    configureScript=../configure
  '';

  # * -t 0 disables use of multi-threading. It's not quite clear what the
  #   consequences of that setting are and whether it's necessary or not.
  configureFlags = [
    "-t ${threads}"
    cpuConfig
  ] ++ optional shared "--shared"
    ++ optional withLapack "--with-netlib-lapack-tarfile=${liblapack.src}";

  postConfigure = ''
    if [[ -n "${cacheEdge}" ]]; then
      echo '#define CacheEdge ${cacheEdge}' >> include/atlas_cacheedge.h
      echo '#define CacheEdge ${cacheEdge}' >> include/atlas_tcacheedge.h
    fi
  '';

  doCheck = true;

  postInstall = ''
    # Avoid name collision with the real lapack (ATLAS only builds a partial
    # lapack unless withLapack = true).
    if ${if withLapack then "false" else "true"}; then
      mv $out/lib/liblapack.a $out/lib/liblapack_atlas.a
    fi
  '';

  meta = {
    homepage = "http://math-atlas.sourceforge.net/";
    description = "Automatically Tuned Linear Algebra Software (ATLAS)";
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.linux;

    longDescription = ''
      The ATLAS (Automatically Tuned Linear Algebra Software) project is an
      ongoing research effort focusing on applying empirical techniques in
      order to provide portable performance. At present, it provides C and
      Fortran77 interfaces to a portably efficient BLAS implementation, as well
      as a few routines from LAPACK.
    '';

    maintainers = with stdenv.lib.maintainers; [ ttuegel ];
  };
}
