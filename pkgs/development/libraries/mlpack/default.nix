{ stdenv, lib, armadillo, boost, cmake, fetchFromGitHub, ensmallen
, enableOpenMP ? false }:

stdenv.mkDerivation rec {
  pname = "mlpack";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "mlpack";
    repo = pname;
    rev = version;
    sha256 = "sha256-/UN/Pmt7m3s9pq4I3XTt0AbHEj3nbbdWeLLcs1TE+9w=";
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
    maintainers = with maintainers; [ aminechikhaoui ];
  };
}
