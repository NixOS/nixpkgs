{ stdenv, fetchFromGitHub, cmake, zlib, netcdf, nifticlib, hdf5 }:

stdenv.mkDerivation rec {
  pname = "libminc";
  name  = "${pname}-2.3.01";

  # current master significantly ahead of most recent release
  src = fetchFromGitHub {
    owner  = "BIC-MNI";
    repo   = pname;
    rev    = "e11c6df9321b4061bf87a7d43171ec55e9e3908f";
    sha256 = "0lmd0js3jgni2mw1zfvd4qg6byxiv3ndgv2z3nm7975i83zw48xk";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ zlib netcdf nifticlib hdf5 ];

  cmakeFlags = [ "-DBUILD_TESTING=${if doCheck then "TRUE" else "FALSE"}"
                 "-DLIBMINC_MINC1_SUPPORT=TRUE"
                 "-DLIBMINC_BUILD_SHARED_LIBS=TRUE"
                 "-DLIBMINC_USE_SYSTEM_NIFTI=TRUE" ];


  checkPhase = ''
    export LD_LIBRARY_PATH="$(pwd)"  # see #22060
    ctest -E ezminc_rw_test --output-on-failure   # ezminc_rw_test can't find libminc_io.so.5.2.0
  '';
  doCheck = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/BIC-MNI/libminc;
    description = "Medical imaging library based on HDF5";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.unix;
  };
}
