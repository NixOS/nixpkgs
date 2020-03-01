{ stdenv, lib, fetchFromGitHub
, cmake, armadillo, openmp
, enableOpenMP ? true }:

stdenv.mkDerivation rec {
  pname = "ensmallen";
  version = "2.11.3";

  src = fetchFromGitHub {
    owner = "mlpack";
    repo = pname;
    rev = version;
    sha256 = "1z9zflj0k6vams48ar193j3yyz7jzdfv5s9kra81himfz91f6ak3";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ armadillo ] ++ (lib.optional enableOpenMP openmp);

  cmakeFlags = [ "-DUSE_OPENMP=${if enableOpenMP then "ON" else "OFF"}" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A header-only C++ library for mathematical optimization";
    homepage = "https://ensmallen.org/";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ eadwu ];
  };
}
