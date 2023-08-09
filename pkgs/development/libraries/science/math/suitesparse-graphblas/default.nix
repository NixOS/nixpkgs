{ lib, stdenv
, fetchFromGitHub
, cmake
, gnum4
}:

stdenv.mkDerivation rec {
  pname = "suitesparse-graphblas";
  version = "7.4.4";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "DrTimothyAldenDavis";
    repo = "GraphBLAS";
    rev = "v${version}";
    sha256 = "sha256-4NLYNapIiEXntXHrsyq63jIbuBJxR77X3VbLFbvtT9A=";
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
