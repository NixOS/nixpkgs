{ lib
, stdenv
, fetchFromGitHub
, cmake
, doxygen
, boost
, eigen
, numpy
, scipy
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "eigenpy";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "stack-of-tasks";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-/k5eltoeUW05FTjvStAOw+tguWLUaUced8TArrk4UDI=";
  };

  cmakeFlags = [
    "-DINSTALL_DOCUMENTATION=ON"
    "-DBUILD_TESTING_SCIPY=ON"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    doxygen
    scipy
  ];

  buildInputs = [
    boost
  ];

  propagatedBuildInputs = [
    eigen
    numpy
  ];

  doCheck = true;
  pythonImportsCheck = [
    "eigenpy"
  ];

  meta = with lib; {
    description = "Bindings between Numpy and Eigen using Boost.Python";
    homepage = "https://github.com/stack-of-tasks/eigenpy";
    changelog = "https://github.com/stack-of-tasks/eigenpy/releases/tag/v${version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ nim65s wegank ];
    platforms = platforms.unix;
  };
})
