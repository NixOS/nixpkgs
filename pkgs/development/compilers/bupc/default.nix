{ stdenv, fetchurl, perl, coreutils }:

stdenv.mkDerivation rec {
  name = "berkeley_upc-2.22.0";

  src = fetchurl {
    url = "http://upc.lbl.gov/download/release/${name}.tar.gz";
    sha256 = "041l215x8z1cvjcx7kwjdgiaf9rl2d778k6kiv8q09bc68nwd44m";
  };

  postPatch = ''
    patchShebangs .
  '';

  # Used during the configure phase
  ENVCMD = "${coreutils}/bin/env";

  nativeBuildInputs = [ coreutils ];
  buildInputs = [ perl ];

  meta = with stdenv.lib; {
    description = "A compiler for the Berkely Unified Parallel C language";
    longDescription = ''
      Unified Parallel C (UPC) is an extension of the C programming language
      designed for high performance computing on large-scale parallel
      machines.The language provides a uniform programming model for both
      shared and distributed memory hardware. The programmer is presented with
      a single shared, partitioned address space, where variables may be
      directly read and written by any processor, but each variable is
      physically associated with a single processor. UPC uses a Single Program
      Multiple Data (SPMD) model of computation in which the amount of
      parallelism is fixed at program startup time, typically with a single
      thread of execution per processor.
    '';
    homepage = http://upc.lbl.gov/;
    license = licenses.mit;
    platforms = with platforms; [ linux ];
    maintainers = with maintainers; [ zimbatm ];
  };
}
