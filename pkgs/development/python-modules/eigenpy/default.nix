{ lib
, stdenv
, fetchFromGitHub
, cmake
, boost
, eigen
, numpy
}:

stdenv.mkDerivation rec {
  pname = "eigenpy";
  version = "2.9.0";

  src = fetchFromGitHub {
    owner = "stack-of-tasks";
    repo = pname;
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-gYGJutTnvq5ERv6tDff6b+t7Kitnx9QAD/6hauHxOt4=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    boost
  ];

  propagatedBuildInputs = [
    eigen
    numpy
  ];

  meta = with lib; {
    description = "Bindings between Numpy and Eigen using Boost.Python";
    homepage = "https://github.com/stack-of-tasks/eigenpy";
    license = licenses.bsd2;
    maintainers = with maintainers; [ wegank ];
    platforms = platforms.unix;
  };
}
