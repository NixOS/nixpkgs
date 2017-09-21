{ stdenv, fetchurl, cmake, zlib, netcdf, hdf5 }:

stdenv.mkDerivation rec {
  _name = "libminc";
  name  = "${_name}-2.3.00";

  src = fetchurl {
    url = "https://github.com/BIC-MNI/${_name}/archive/${_name}-2-3-00.tar.gz";
    sha256 = "04ngqx4wkssxs9qqcgq2bvfs1cldcycmpcx587wy3b3m6lwf004c";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ zlib netcdf hdf5 ];

  cmakeFlags = [ "-DLIBMINC_BUILD_SHARED_LIBS=ON"
                 "-DLIBMINC_MINC1_SUPPORT=ON" ];

  checkPhase = "ctest";

  meta = with stdenv.lib; {
    homepage = https://github.com/BIC-MNI/libminc;
    description = "Medical imaging library based on HDF5";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.unix;
  };
}
