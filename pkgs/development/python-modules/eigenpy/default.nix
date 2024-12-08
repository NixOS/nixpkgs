{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cmake,
  doxygen,
  boost,
  eigen,
  jrl-cmakemodules,
  numpy,
  scipy,
}:

buildPythonPackage rec {
  pname = "eigenpy";
  version = "3.10.1";
  pyproject = false; # Built with cmake

  src = fetchFromGitHub {
    owner = "stack-of-tasks";
    repo = "eigenpy";
    rev = "refs/tags/v${version}";
    hash = "sha256-9hKYCCKgPn1IJDezX/ARJHr5+0ridmGd1b3k/ZaVRG0=";
  };

  outputs = [
    "dev"
    "doc"
    "out"
  ];

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

  buildInputs = [ boost ];

  propagatedBuildInputs = [
    eigen
    jrl-cmakemodules
    numpy
  ];

  pythonImportsCheck = [ "eigenpy" ];

  meta = with lib; {
    description = "Bindings between Numpy and Eigen using Boost.Python";
    homepage = "https://github.com/stack-of-tasks/eigenpy";
    changelog = "https://github.com/stack-of-tasks/eigenpy/releases/tag/v${version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [
      nim65s
      wegank
    ];
    platforms = platforms.unix;
  };
}
