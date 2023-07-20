{ lib
, stdenv
, fetchFromGitHub
, cmake
, pythonSupport ? false
, python3Packages
}:

stdenv.mkDerivation rec {
  pname = "example-robot-data";
  version = "4.0.7";

  src = fetchFromGitHub {
    owner = "Gepetto";
    repo = pname;
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-dN23ukKPkTohqD1J/0EneLyG6Cg0zriMr1l6WLFemd8=";
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

  meta = with lib; {
    description = "Set of robot URDFs for benchmarking and developed examples.";
    homepage = "https://github.com/Gepetto/example-robot-data";
    license = licenses.bsd3;
    maintainers = with maintainers; [ wegank ];
    platforms = platforms.unix;
  };
}
