{ stdenv, fetchurl, gfortran, cmake, openmpi }:

stdenv.mkDerivation rec {
  name = "hypre";
  version = "2.14.0";

  src = fetchurl {
    url = "https://github.com/LLNL/hypre/archive/v${version}.tar.gz";
    sha256 = "0v515i73bvaz378h5465b1dy9v2gf924zy2q94cpq4qqarawvkqh";
  };

  sourceRoot = "${name}-${version}/src";

  preConfigure = ''
    cmakeFlags="$cmakeFlags -DHYPRE_INSTALL_PREFIX=$out -DHYPRE_SHARED=ON -DCMAKE_SHARED_LINKER_FLAGS=\"-lmpi\""
  '';

  buildInputs = [ cmake gfortran openmpi ];

  meta = {
    description = "Scalable linear solvers and multigrid methods";
    homepage = https://computation.llnl.gov/projects/hypre-scalable-linear-solvers-multigrid-methods;
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.all;
    maintainers = with stdenv.lib.maintainers; [ jamtrott ];
  };
}
