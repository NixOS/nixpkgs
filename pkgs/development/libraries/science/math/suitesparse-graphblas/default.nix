{ lib, stdenv
, fetchFromGitHub
, cmake
, gnum4
}:

stdenv.mkDerivation rec {
  pname = "suitesparse-graphblas";
  version = "6.2.5";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "DrTimothyAldenDavis";
    repo = "GraphBLAS";
    rev = "v${version}";
    sha256 = "sha256-N4yFlTxV+lVz70PSHPuWEEFLp0dpsImXYDLUYEo2JQI=";
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
