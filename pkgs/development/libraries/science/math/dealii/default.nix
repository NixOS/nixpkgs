{ lib
, stdenv
, fetchzip
, fetchFromGitHub
, symlinkJoin
, cmake
, boost
, withThreading ? true, tbb
, withMPI ? true, mpi
, with64bitIndices ? false
, minimal ? false
, doxygen
, perl
, graphviz
, arpack
, assimp
, blas
, lapack
, gmsh
, gsl
, hdf5
, hdf5-mpi
, metis
, muparser
, p4est
, p4est-sc
, petsc
, scalapack
, symengine
, zlib
, suitesparse
, openssh
}:

# Check PETSc compatibility
assert withMPI -> petsc.mpiSupport;

let
  version = "9.4.0";

  hdf5ToUse = if withMPI then hdf5-mpi else hdf5;

  # default PETSc in nixpkgs doesn't support 64-bit indices
  petscEnabled = (!minimal) && (!with64bitIndices);

  offlineDocs = fetchzip {
    url = "https://dealii.43-1.org/downloads/dealii-${version}-offline_documentation.tar.gz";
    sha256 = "sha256-368Dd8DCgoXw0vSyuDQYiDlZjNjVVf23RvyCX/RC9+4=";
    stripRoot = false;
  };
in stdenv.mkDerivation rec {
  pname = "dealii";
  inherit version;

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-2ZzeSXqUaZ/yRyQy80XugEwKmLkED+stQx+KRyv25LA=";
  };

  postPatch = ''
    patchShebangs doc/doxygen/scripts/
  '';


  nativeBuildInputs = [ cmake doxygen perl graphviz ];
  buildInputs = [ boost hdf5ToUse zlib blas lapack ]
    ++ lib.optionals withThreading [ tbb ]
    ++ lib.optionals withMPI [ mpi metis p4est p4est-sc ]
    ++ lib.optionals petscEnabled [ petsc ]
    ++ lib.optionals (!minimal) [
      arpack assimp gmsh gsl muparser suitesparse symengine scalapack
    ];
  checkInputs = lib.optionals (withMPI && mpi.pname == "openmpi") [ openssh ];

  outputs = [ "out" "doc" ];

  cmakeFlags = [
      "-DCMAKE_BUILD_TYPE=DebugRelease"
      "-DDEAL_II_ALLOW_BUNDLED=OFF"
      "-DDEAL_II_ALLOW_AUTODETECTION=OFF"
      "-DDEAL_II_WITH_BOOST=ON" "-DBOOST_DIR=${boost}"
      "-DDEAL_II_WITH_ZLIB=ON" "-DZLIB_DIR=${zlib}"
      "-DDEAL_II_WITH_HDF5=ON" "-DHDF5_DIR=${hdf5ToUse.dev}"
      "-DBLAS_DIR=${blas}"
      "-DDEAL_II_WITH_LAPACK=ON" "-DLAPACK_DIR=${lapack}"
      "-DDEAL_II_COMPONENT_DOCUMENTATION=ON"
      "-DDEAL_II_COMPONENT_EXAMPLES=OFF"
      "-DDEAL_II_DOXYGEN_USE_MATHJAX=ON"
      # deal.II needs mathjax 2, which isn't available in Nixpkgs
      "-DDEAL_II_DOXYGEN_USE_ONLINE_MATHJAX=ON"
    ]
    ++ lib.optionals withThreading  [
      "-DDEAL_II_WITH_TBB=ON" "-DTBB_DIR=${tbb}"
    ]
    ++ lib.optionals withMPI [
      "-DDEAL_II_WITH_MPI=ON"
      "-DDEAL_II_WITH_METIS=ON" "-DMETIS_DIR=${metis}"
      "-DDEAL_II_WITH_P4EST=ON" "-DP4EST_DIR=${p4est}" "-DSC_DIR=${p4est-sc}"
    ]
    ++ lib.optionals with64bitIndices [ "-DDEAL_II_WITH_64BIT_INDICES=ON" ]
    ++ lib.optionals petscEnabled [
      "-DDEAL_II_WITH_PETSC=ON" "-DPETSC_DIR=${petsc}"
    ]
    ++ lib.optionals (!minimal) [
      "-DDEAL_II_WITH_MUPARSER=ON" "-DMUPARSER_DIR=${muparser}"
      "-DDEAL_II_WITH_ARPACK=ON" "-DARPACK_DIR=${arpack}"
      "-DDEAL_II_WITH_ASSIMP=ON" "-DASSIMP_DIR=${assimp}"
      "-DDEAL_II_WITH_GMSH=ON" "-DGMSH_DIR=${gmsh}"
      "-DDEAL_II_WITH_GSL=ON" "-DGSL_DIR=${gsl}"
      "-DDEAL_II_WITH_SCALAPACK=ON" "-DSCALAPACK_DIR=${scalapack}"
      "-DDEAL_II_WITH_SYMENGINE=ON" "-DSYMENGINE_DIR=${symengine}"
      "-DDEAL_II_WITH_UMFPACK=ON" "-DUMFPACK_DIR=${suitesparse}"
    ];

  postBuild = ''
    make documentation
    cp -r ${offlineDocs}/doc/doxygen/deal.II/images doc/doxygen/deal.II
  '';

  postInstall = ''
    for fname in detailed.log summary.log; do
      install -Dm644 $fname $out/$fname
    done

    for f in $(find $outputDoc -name '*.html'); do
      sed -i 's#"https://www.dealii.org/images/#"images/#g' $f
    done
  '';

  doCheck = true;
  preCheck = ''
    export LD_LIBRARY_PATH=$PWD/lib:$LD_LIBRARY_PATH
    export PATH=${mpi}/bin:$PATH
  '';

  passthru = {
    inherit withMPI mpi;
  };

  meta = with lib; {
    description = "C++ software library supporting the creation of finite element codes";
    longDescription = ''
      deal.II is a C++ program library targeted at the computational solution of
      partial differential equations using adaptive finite elements. It uses
      state-of-the-art programming techniques to offer you a modern interface to
      the complex data structures and algorithms required.
    '';
    homepage = "https://www.dealii.org/";
    downloadPage = "https://github.com/dealii/dealii/releases";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ yl3dy ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
