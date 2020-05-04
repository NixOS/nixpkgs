{ stdenv
, fetchFromGitHub
, cmake
, gnum4
}:

stdenv.mkDerivation rec {
  pname = "suitesparse-graphblas";
  version = "3.2.2";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "DrTimothyAldenDavis";
    repo = "GraphBLAS";
    rev = "v${version}";
    sha256 = "04hprrgj0f44ml2f0w4jfwgrvy8l2s6ya0c9xc8gwlbmkc7a4c62";
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
