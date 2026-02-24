{
  lib,
  stdenv,
  fetchurl,
  gfortran,
  pkg-config,
  libtool,
  m4,
  gnum4,
  file,
  # Memory Hierarchy (End-user can provide this.)
  memHierarchy ? "",
  # Headers/Libraries
  blas,
  zlib,
  # RPC headers (rpc/xdr.h)
  openmpi,
  help2man,
  doxygen,
  octave,
}:

stdenv.mkDerivation rec {
  pname = "librsb";
  version = "1.3.0.2";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.gz";
    sha256 = "sha256-GMb8RD+hz9KoEQ99S4jVu8tJO56Fs6YgFLi7V6hI4E8=";
  };

  # The default configure flags are still present when building
  # --disable-static --disable-dependency-tracking
  # Along with the --prefix=... flag (but we want that one).
  configureFlags = [
    "--enable-static"
    "--enable-doc-build"
    "--enable-octave-testing"
    "--enable-sparse-blas-interface"
    "--enable-fortran-module-install"
    "--enable-pkg-config-install"
    "--enable-matrix-types=all"
    "--with-zlib=${zlib}/lib/libz.so"
    "--with-memhinfo=${memHierarchy}"
  ];

  # Ensure C/Fortran code is position-independent.
  env.NIX_CFLAGS_COMPILE = toString [
    "-fPIC"
    "-Ofast"
  ];
  FCFLAGS = [
    "-fPIC"
    "-Ofast"
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [
    gfortran
    pkg-config
    libtool
    m4
    gnum4
    file
    blas
    zlib
    openmpi
    octave
    help2man # Turn "--help" into a man-page
    doxygen # Build documentation
  ];

  # Need to run cleanall target to remove any previously-generated files.
  preBuild = ''
    make cleanall
  '';

  nativeCheckInputs = [
    octave
  ];
  checkTarget = "tests";

  meta = {
    homepage = "https://librsb.sourceforge.net/";
    description = "Shared memory parallel sparse matrix and sparse BLAS library";
    longDescription = ''
      Library for sparse matrix computations featuring the Recursive Sparse
      Blocks (RSB) matrix format. This format allows cache efficient and
      multi-threaded (that is, shared memory parallel) operations on large
      sparse matrices.
      librsb implements the Sparse BLAS standard, as specified in the BLAS
      Forum documents.
      Contains libraries and header files for developing applications that
      want to make use of librsb.
    '';
    license = with lib.licenses; [ lgpl3Plus ];
    maintainers = with lib.maintainers; [ KarlJoad ];
    platforms = lib.platforms.all;
    # linking errors such as 'undefined reference to `gzungetc'
    broken = true;
  };
}
