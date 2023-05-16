{ lib
, stdenv
, fetchFromGitHub
, cmake
, boost
, eigen
, numpy
}:

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
  pname = "eigenpy";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "stack-of-tasks";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-mUwckBelFVRCXp3hspB8WRFFaLVyRsfp6XbqU8HeHvw=";
=======
stdenv.mkDerivation rec {
  pname = "eigenpy";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "stack-of-tasks";
    repo = pname;
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-xaeMsn3G4x5DS6gXc6mbZvi96K1Yu8CuzjcGnYJYrvs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
  doCheck = true;
  pythonImportsCheck = [
    "eigenpy"
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Bindings between Numpy and Eigen using Boost.Python";
    homepage = "https://github.com/stack-of-tasks/eigenpy";
    changelog = "https://github.com/stack-of-tasks/eigenpy/releases/tag/v${version}";
    license = licenses.bsd2;
<<<<<<< HEAD
    maintainers = with maintainers; [ nim65s wegank ];
    platforms = platforms.unix;
  };
})
=======
    maintainers = with maintainers; [ wegank ];
    platforms = platforms.unix;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
