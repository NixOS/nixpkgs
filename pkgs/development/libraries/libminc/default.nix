{ stdenv, fetchFromGitHub, cmake, zlib, netcdf, hdf5 }:

stdenv.mkDerivation rec {
  name = "${pname}-2.3.00";
  pname = "libminc";

  src = fetchFromGitHub {
    owner = "BIC-MNI";
    repo = pname;
    rev = builtins.replaceStrings [ "." ] [ "-" ] name;
    sha256 = "1gv1rq1q1brhglll2256cm6sns77ph6fvgbzk3ihkzq46y07yi9s";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ zlib netcdf hdf5 ];

  cmakeFlags = [ "-DBUILD_TESTING=${if doCheck then "ON" else "OFF"}"
                 "-DLIBMINC_MINC1_SUPPORT=ON" ];

  checkPhase = "ctest";
  doCheck = true;

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/BIC-MNI/libminc;
    description = "Medical imaging library based on HDF5";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.unix;
  };
}
