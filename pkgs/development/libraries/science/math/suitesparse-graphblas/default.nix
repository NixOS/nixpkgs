{ stdenv
, fetchFromGitHub
, cmake
, gnum4
}:

stdenv.mkDerivation rec {
  pname = "suitesparse-graphblas";
  version = "3.3.0";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "DrTimothyAldenDavis";
    repo = "GraphBLAS";
    rev = "v${version}";
    sha256 = "1fin9741ild3dv7c9gk07kpizsnnx17ar9cv9lny8vl47pms940h";
  };

  nativeBuildInputs = [
    cmake
    gnum4
  ];

  meta = with stdenv.lib; {
    description = "Graph algorithms in the language of linear algebra";
    homepage = "http://faculty.cse.tamu.edu/davis/GraphBLAS.html";
    license = licenses.asl20;
    maintainers = with maintainers; [];
    platforms = with platforms; unix;
  };
}
