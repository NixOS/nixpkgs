{ stdenv, lib, fetchurl, gfortran, pkgconfig
, blas, zlib, bzip2
, withGurobi ? false, gurobi
, withCplex ? false, cplex }:

stdenv.mkDerivation rec {
  pname = "osi";
  version = "0.108.4";

  src = fetchurl {
    url = "https://www.coin-or.org/download/source/Osi/Osi-${version}.tgz";
    sha256 = "13bwhdh01g37vp3kjwl9nvij5s5ikh5f7zgrqgwrqfyk35q2x9s5";
  };

  buildInputs =
    [ blas zlib bzip2 ]
    ++ lib.optional withGurobi gurobi
    ++ lib.optional withCplex cplex;
  nativeBuildInputs = [ gfortran pkgconfig ];
  configureFlags =
    lib.optionals withGurobi [ "--with-gurobi-incdir=${gurobi}/include" "--with-gurobi-lib=-lgurobi${gurobi.libSuffix}" ]
    ++ lib.optionals withCplex [ "--with-cplex-incdir=${cplex}/cplex/include/ilcplex" "--with-cplex-lib=-lcplex${cplex.libSuffix}" ];

  NIX_LDFLAGS =
    lib.optionalString withCplex "-L${cplex}/cplex/bin/${cplex.libArch}";

  # Compile errors
  NIX_CFLAGS_COMPILE = "-Wno-cast-qual";
  hardeningDisable = [ "format" ];

  enableParallelBuilding = true;

  passthru = { inherit withGurobi withCplex; };

  meta = with stdenv.lib; {
    description = "An abstract base class to a generic linear programming (LP) solver";
    homepage = "https://github.com/coin-or/Osi";
    license = licenses.epl10;
    platforms = platforms.unix;
    maintainers = with maintainers; [ abbradar ];
  };
}
