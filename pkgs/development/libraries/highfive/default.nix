{
  stdenv
, fetchFromGitHub
, cmake
, boost
, eigen
, hdf5
}:

let
  version = "2.1.1";
  mpiSupport = hdf5.mpiSupport;
  mpi = hdf5.mpi;
in
stdenv.mkDerivation {
  pname = "highfive";
  inherit version;

  src = fetchFromGitHub {
    owner = "BlueBrain";
    repo = "HighFive";
    rev = "b9b25da543145166b01bcca01c3cbedfcbd06307";
    sha256 = "0ci9vv9laav5a3awrvvdrfc10z0n5baiav7q4lxxrzclgmla1nnc";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ boost eigen hdf5 ];

  passthru = {
    mpiSupport = mpiSupport;
    inherit mpi;
  };

  cmakeFlags = [
    "-DUSE_BOOST=ON"  # In the next release will be HIGHFIVE_USE_BOOST
    "-DUSE_EIGEN=ON"  # In the next release will be HIGHFIVE_USE_EIGEN
    "-DHIGHFIVE_EXAMPLES=OFF"
    "-DHIGHFIVE_UNIT_TESTS=OFF"
  ]
  ++ (stdenv.lib.optionals mpiSupport [ "-DHIGHFIVE_PARALLEL_HDF5=ON" ]);

  meta = with stdenv.lib; {
    inherit version;
    description = "Header-only C++ HDF5 interface";
    license = licenses.boost;
    homepage = https://bluebrain.github.io/HighFive/ ;
    platforms = platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ robertodr ];
  };
}
