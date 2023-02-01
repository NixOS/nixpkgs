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
  version = "2.9.1";

  src = fetchFromGitHub {
    owner = "stack-of-tasks";
    repo = pname;
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-R+j68l2N+Qb2uqdl+Ng6nwj8O3YhqXgnYZBIzZ06aRA=";
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
    changelog = "https://github.com/stack-of-tasks/eigenpy/releases/tag/v${version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ wegank ];
    platforms = platforms.unix;
  };
}
