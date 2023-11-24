{ lib
, stdenv
, fetchFromGitHub
, cmake
, boost
, eigen
, numpy
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "eigenpy";
  version = "3.1.3";

  src = fetchFromGitHub {
    owner = "stack-of-tasks";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-8UuJA96pkXXRKDzQTjoz7w8TQrS5+nfLdsT0j9/oqz0=";
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
