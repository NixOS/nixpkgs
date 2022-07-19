{ lib, stdenv, fetchFromGitHub, cmake, zlib, netcdf, nifticlib, hdf5 }:

stdenv.mkDerivation rec {
  pname   = "libminc";
  version = "unstable-2020-07-17";

  owner = "BIC-MNI";

  src = fetchFromGitHub {
    inherit owner;
    repo   = pname;
    rev    = "ffb5fb234a852ea7e8da8bb2b3b49f67acbe56ca";
    sha256 = "0yr4ksghpvxh9zg0a4p7hvln3qirsi08plvjp5kxx2qiyj96zsdm";
  };

  postPatch = ''
    patchShebangs .
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [ zlib nifticlib ];
  propagatedBuildInputs = [ netcdf hdf5 ];

  cmakeFlags = [
    "-DLIBMINC_MINC1_SUPPORT=ON"
    "-DLIBMINC_BUILD_SHARED_LIBS=ON"
    "-DLIBMINC_USE_SYSTEM_NIFTI=ON"
  ];

  doCheck = !stdenv.isDarwin;
  checkPhase = ''
    ctest -j1 -E 'ezminc_rw_test' --output-on-failure
    # -j1: see https://github.com/BIC-MNI/libminc/issues/110
    # ezminc_rw_test: can't find libminc_io.so.5.2.0
  '';

  meta = with lib; {
    homepage = "https://github.com/BIC-MNI/libminc";
    description = "Medical imaging library based on HDF5";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.unix;
    license = licenses.free;
  };
}
