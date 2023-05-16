{ lib
, stdenv
, fetchFromGitHub
, cmake
, pythonSupport ? false
, python3Packages
}:

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
  pname = "example-robot-data";
  version = "4.0.8";

  src = fetchFromGitHub {
    owner = "Gepetto";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-xeNbx1f9QCAOJrXfkk3jo9XH2/4HNtnRA1OSnqA2cLs=";
=======
stdenv.mkDerivation rec {
  pname = "example-robot-data";
  version = "4.0.5";

  src = fetchFromGitHub {
    owner = "Gepetto";
    repo = pname;
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-KE+wmYlgETt6RtyN/BMApgS075/WtuhY+rM7YFkBH0E=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = lib.optionals pythonSupport [
    python3Packages.pinocchio
  ];

  cmakeFlags = lib.optionals (!pythonSupport) [
    "-DBUILD_PYTHON_INTERFACE=OFF"
  ];

<<<<<<< HEAD
  doCheck = true;
  # The package expect to find an `example-robot-data/robots` folder somewhere
  # either in install prefix or in the sources
  # where it can find the meshes for unit tests
  preCheck = "ln -s source ../../${finalAttrs.pname}";
  pythonImportsCheck = [
    "example_robot_data"
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Set of robot URDFs for benchmarking and developed examples.";
    homepage = "https://github.com/Gepetto/example-robot-data";
    license = licenses.bsd3;
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
