{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  doxygen,
  boost,
  eigen,
  jrl-cmakemodules,
  numpy,
  scipy,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "eigenpy";
  version = "3.5.1";

  src = fetchFromGitHub {
    owner = "stack-of-tasks";
    repo = "eigenpy";
    rev = "v${finalAttrs.version}";
    hash = "sha256-nTS9FNXGrak5g83BHHNSsk5V5khpOpRz5zWE8D1gDUo=";
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

  doCheck = true;
  pythonImportsCheck = [ "eigenpy" ];

  meta = with lib; {
    description = "Bindings between Numpy and Eigen using Boost.Python";
    homepage = "https://github.com/stack-of-tasks/eigenpy";
    changelog = "https://github.com/stack-of-tasks/eigenpy/releases/tag/v${finalAttrs.version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [
      nim65s
      wegank
    ];
    platforms = platforms.unix;
  };
})
