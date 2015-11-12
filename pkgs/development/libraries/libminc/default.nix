{ stdenv, fetchurl, cmake, zlib, netcdf, hdf5 }:

stdenv.mkDerivation rec {
  name = "libminc-2.3.00";

  src = fetchurl {
    url = "https://github.com/BIC-MNI/libminc/archive/libminc-2-3-00.tar.gz";
    sha256 = "04ngqx4wkssxs9qqcgq2bvfs1cldcycmpcx587wy3b3m6lwf004c";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ zlib netcdf hdf5 ];

  cmakeFlags = [ "-DBUILD_TESTING=${if doCheck then "ON" else "OFF"}"
                 "-DLIBMINC_MINC1_SUPPORT=ON" ];

  checkPhase = "ctest";
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/BIC-MNI/libminc";
    description = "Medical imaging library based on HDF5";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.unix;
  };
}
