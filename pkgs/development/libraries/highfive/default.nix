{ stdenv
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
  pname = "highfive";
  version = "2.2";

  src = fetchFromGitHub {
    owner = "BlueBrain";
    repo = "HighFive";
    rev = "4c70d818ed18231563fe49ff197d1c41054be592";
    sha256 = "02xy3c2ix3nw8109aw75ixj651knzc5rjqwqrxximm4hzwx09frk";
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
  ++ (stdenv.lib.optionals mpiSupport [ "-DHIGHFIVE_PARALLEL_HDF5=ON" ]);

  meta = with stdenv.lib; {
    inherit version;
    description = "Header-only C++ HDF5 interface";
    license = licenses.boost;
    homepage = "https://bluebrain.github.io/HighFive/";
    platforms = platforms.unix;
    maintainers = with maintainers; [ robertodr ];
  };
}
