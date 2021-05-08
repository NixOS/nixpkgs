{ lib, stdenv
, fetchFromGitHub
, cmake
, gnum4
}:

stdenv.mkDerivation rec {
  pname = "suitesparse-graphblas";
  version = "4.0.3";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "DrTimothyAldenDavis";
    repo = "GraphBLAS";
    rev = "v${version}";
    sha256 = "sha256-Bf3+w/kQtFpeUGp2zWVqja535EbaUw7DbhCw54B6A8k=";
  };

  nativeBuildInputs = [
    cmake
    gnum4
  ];

  meta = with lib; {
    description = "Graph algorithms in the language of linear algebra";
    homepage = "http://faculty.cse.tamu.edu/davis/GraphBLAS.html";
    license = licenses.asl20;
    maintainers = with maintainers; [];
    platforms = with platforms; unix;
  };
}
