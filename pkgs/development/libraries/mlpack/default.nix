{ stdenv, lib, fetchFromGitHub
, cmake, armadillo, boost, ensmallen
, enableOpenMP ? true }:

stdenv.mkDerivation rec {
  pname = "mlpack";
  version = "3.2.2";

  src = fetchFromGitHub {
    owner = "mlpack";
    repo = pname;
    rev = version;
    sha256 = "0cazsm4gh23lsgdhq94cr8m27jnvdfyxavdvb26wzs1f859xqvhz";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ armadillo boost ensmallen ];

  cmakeFlags = [ "-DUSE_OPENMP=${if enableOpenMP then "ON" else "OFF"}" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A scalable C++ machine learning library";
    homepage = "https://www.mlpack.org/";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ eadwu ];
  };
}
