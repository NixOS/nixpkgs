{ fetchurl, stdenv, ppl }:

stdenv.mkDerivation rec {
  name = "cloog-ppl-0.15.4";

  src = fetchurl {
    url = "mirror://gcc/infrastructure/${name}.tar.gz";
    sha256 = "133b6ayi6wmvbmvd4y1w1xh01qy38kp59n87j7apkm2ig8avfnmm";
  };

  propagatedBuildInputs = [ ppl ];

  configureFlags = "--with-ppl=${ppl}";

  doCheck = true;

  meta = {
    description = "CLooG-PPL, the Chunky Loop Generator";

    longDescription = ''
      CLooG is a free software library to generate code for scanning
      Z-polyhedra.  That is, it finds a code (e.g., in C, FORTRAN...) that
      reaches each integral point of one or more parameterized polyhedra.
      CLooG has been originally written to solve the code generation problem
      for optimizing compilers based on the polytope model.  Nevertheless it
      is used now in various area e.g., to build control automata for
      high-level synthesis or to find the best polynomial approximation of a
      function.  CLooG may help in any situation where scanning polyhedra
      matters.  While the user has full control on generated code quality,
      CLooG is designed to avoid control overhead and to produce a very
      effective code.
    '';

    # CLooG-PPL is actually a port of GLooG from PolyLib to PPL.
    homepage = http://www.cloog.org/;

    license = "GPLv2+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
