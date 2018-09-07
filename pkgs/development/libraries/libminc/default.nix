{ stdenv, fetchFromGitHub, cmake, zlib, netcdf, nifticlib, hdf5 }:

stdenv.mkDerivation rec {
  pname = "libminc";
  name  = "${pname}-2018-01-17";

  owner = "BIC-MNI";

  # current master is significantly ahead of most recent release, so use Git version:
  src = fetchFromGitHub {
    inherit owner;
    repo   = pname;
    rev    = "a9cbe1353eae9791b7d5b03af16e0f86922ce40b";
    sha256 = "0mn4n3ihzcr1jw2g1vy6c8p4lkc88jwljk04argmj7k4djrgpxpa";
  };

  postPatch = ''
    patchShebangs .
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [ zlib netcdf nifticlib hdf5 ];

  cmakeFlags = [
    "-DBUILD_TESTING=${if doCheck then "ON" else "OFF"}"
    "-DLIBMINC_MINC1_SUPPORT=ON"
    "-DLIBMINC_BUILD_SHARED_LIBS=ON"
    "-DLIBMINC_USE_SYSTEM_NIFTI=ON"
  ];

  doCheck = stdenv.buildPlatform == stdenv.hostPlatform;
  checkPhase = ''
    export LD_LIBRARY_PATH="$(pwd)"  # see #22060
    ctest -E 'ezminc_rw_test|minc_conversion' --output-on-failure
    # ezminc_rw_test can't find libminc_io.so.5.2.0; minc_conversion hits netcdf compilation issue
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "https://github.com/${owner}/${pname}";
    description = "Medical imaging library based on HDF5";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.unix;
    license   = licenses.free;
  };
}
