{ fetchurl, stdenv, ppl }:

stdenv.mkDerivation rec {
  name = "cloog-ppl-0.15.11";

  src = fetchurl {
    url = "mirror://gcc/infrastructure/${name}.tar.gz";
    sha256 = "0psdm0bn5gx60glfh955x5b3b23zqrd92idmjr0b00dlnb839mkw";
  };

  propagatedBuildInputs = [ ppl ];

  configureFlags = "--with-ppl=${ppl}";

  crossAttrs = {
    configureFlags = "--with-ppl=${ppl.crossDrv}";
  };

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

    /* Leads to an ICE on Cygwin:

       make[3]: Entering directory `/tmp/nix-build-9q5gw5m37q5l4f0kjfv9ar8fsc9plk27-ppl-0.10.2.drv-1/ppl-0.10.2/src'
       /bin/sh ../libtool --tag=CXX   --mode=compile g++ -DHAVE_CONFIG_H -I. -I..  -I.. -I../src    -g -O2 -frounding-math  -W -Wall -c -o Box.lo Box.cc
       libtool: compile:  g++ -DHAVE_CONFIG_H -I. -I.. -I.. -I../src -g -O2 -frounding-math -W -Wall -c Box.cc  -DDLL_EXPORT -DPIC -o .libs/Box.o
       In file included from checked.defs.hh:595,
                        from Checked_Number.defs.hh:27,
                        from Coefficient.types.hh:15,
                        from Coefficient.defs.hh:26,
                        from Box.defs.hh:28,
                        from Box.cc:24:
       checked.inlines.hh: In function `Parma_Polyhedra_Library::Result Parma_Polyhedra_Library::Checked::input_generic(Type&, std::istream&, Parma_Polyhedra_Library::Rounding_Dir)':
       checked.inlines.hh:607: internal compiler error: in invert_truthvalue, at fold-const.c:2719
       Please submit a full bug report,
       with preprocessed source if appropriate.
       See <URL:http://cygwin.com/problems.html> for instructions.
       make[3]: *** [Box.lo] Error 1

    */
    platforms = stdenv.lib.platforms.allBut "i686-cygwin";
  };
}
