{ lib
, stdenv
, fetchFromGitHub
<<<<<<< HEAD
, fetchpatch
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, cmake
, example-robot-data
, pinocchio
, pythonSupport ? false
, python3Packages
}:

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
  pname = "crocoddyl";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "loco-3d";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-h7rzLSvmWOZCP8rvmUEhFeMEiPhojfbvkt+fNKpgoXo=";
=======
stdenv.mkDerivation rec {
  pname = "crocoddyl";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "loco-3d";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-IQ+8ZZXVTTRFa4uGetpylRab4P9MSTU2YtytYA3z6ys=";
    fetchSubmodules = true;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
  ];

  propagatedBuildInputs = lib.optionals (!pythonSupport) [
    example-robot-data
    pinocchio
  ] ++ lib.optionals pythonSupport [
    python3Packages.example-robot-data
    python3Packages.pinocchio
  ];

  cmakeFlags = lib.optionals (!pythonSupport) [
    "-DBUILD_EXAMPLES=OFF"
    "-DBUILD_PYTHON_INTERFACE=OFF"
  ];

<<<<<<< HEAD
  prePatch = ''
    substituteInPlace \
      examples/CMakeLists.txt \
      examples/log/check_logfiles.sh \
      --replace /bin/bash ${stdenv.shell}
  '';

  doCheck = true;
  pythonImportsCheck = [
    "crocoddyl"
  ];
  checkInputs = lib.optionals (pythonSupport) [
    python3Packages.scipy
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Crocoddyl optimal control library";
    homepage = "https://github.com/loco-3d/crocoddyl";
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
