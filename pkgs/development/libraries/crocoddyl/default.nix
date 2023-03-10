{ lib
, stdenv
, fetchFromGitHub
, cmake
, example-robot-data
, pinocchio
, pythonSupport ? false
, python3Packages
}:

stdenv.mkDerivation rec {
  pname = "crocoddyl";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "loco-3d";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-IQ+8ZZXVTTRFa4uGetpylRab4P9MSTU2YtytYA3z6ys=";
    fetchSubmodules = true;
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

  meta = with lib; {
    description = "Crocoddyl optimal control library";
    homepage = "https://github.com/loco-3d/crocoddyl";
    license = licenses.bsd3;
    maintainers = with maintainers; [ wegank ];
    platforms = platforms.unix;
  };
}
