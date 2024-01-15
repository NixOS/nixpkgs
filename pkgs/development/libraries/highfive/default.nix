{ lib, stdenv
, fetchFromGitHub
, cmake
, boost
, eigen
, hdf5
, mpiSupport ? hdf5.mpiSupport
, mpi ? hdf5.mpi
}:

assert mpiSupport -> mpi != null;

stdenv.mkDerivation rec {
  pname = "highfive${lib.optionalString mpiSupport "-mpi"}";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "BlueBrain";
    repo = "HighFive";
    rev = "v${version}";
    sha256 = "sha256-INDQ0RqPMSsKXQ/QVDhpCg4qzghLA3zQUViduflLUFY=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ boost eigen hdf5 ];

  passthru = {
    inherit mpiSupport mpi;
  };

  cmakeFlags = [
    "-DHIGHFIVE_USE_BOOST=ON"
    "-DHIGHFIVE_USE_EIGEN=ON"
    "-DHIGHFIVE_EXAMPLES=OFF"
    "-DHIGHFIVE_UNIT_TESTS=OFF"
    "-DHIGHFIVE_USE_INSTALL_DEPS=ON"
  ]
  ++ (lib.optionals mpiSupport [ "-DHIGHFIVE_PARALLEL_HDF5=ON" ]);

  meta = with lib; {
    description = "Header-only C++ HDF5 interface";
    license = licenses.boost;
    homepage = "https://bluebrain.github.io/HighFive/";
    platforms = platforms.unix;
    maintainers = with maintainers; [ robertodr ];
  };
}
