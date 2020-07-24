{ stdenv, fetchFromGitHub, cmake, zlib, netcdf, nifticlib, hdf5 }:

stdenv.mkDerivation rec {
  pname   = "libminc";
  version = "2.4.03";

  owner = "BIC-MNI";

  src = fetchFromGitHub {
    inherit owner;
    repo   = pname;
    rev    = "release-${version}";
    sha256 = "0kpmqs9df836ywsqj749qbsfavf5bnldblxrmnmxqq9pywc8yfrm";
  };

  postPatch = ''
    patchShebangs .
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [ zlib netcdf nifticlib hdf5 ];

  cmakeFlags = [
    "-DLIBMINC_MINC1_SUPPORT=ON"
    "-DLIBMINC_BUILD_SHARED_LIBS=ON"
    "-DLIBMINC_USE_SYSTEM_NIFTI=ON"
  ];

  doCheck = !stdenv.isDarwin;
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
