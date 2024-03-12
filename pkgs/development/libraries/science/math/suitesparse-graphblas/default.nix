{ lib
, stdenv
, fetchFromGitHub
, cmake
, gnum4
}:

stdenv.mkDerivation rec {
  pname = "suitesparse-graphblas";
  version = "9.0.3";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "DrTimothyAldenDavis";
    repo = "GraphBLAS";
    rev = "v${version}";
    hash = "sha256-qRRrxMshLLEltCzXFv/j6NgRi6x1SHlAuKG5NfLiBFs=";
  };

  nativeBuildInputs = [
    cmake
    gnum4
  ];

  preConfigure = ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    description = "Graph algorithms in the language of linear algebra";
    homepage = "https://people.engr.tamu.edu/davis/GraphBLAS.html";
    license = licenses.asl20;
    maintainers = with maintainers; [ wegank ];
    platforms = with platforms; unix;
  };
}
