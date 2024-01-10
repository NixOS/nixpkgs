{ lib
, stdenv
, fetchFromGitHub
, cmake
, pythonSupport ? false
, python3Packages
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "example-robot-data";
  version = "4.0.9";

  src = fetchFromGitHub {
    owner = "Gepetto";
    repo = "example-robot-data";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-dLW8QaQhTTDcE4QCP9uV4ykOqwc3nbPUmF1B77r8CHQ=";
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

  doCheck = true;
  # The package expect to find an `example-robot-data/robots` folder somewhere
  # either in install prefix or in the sources
  # where it can find the meshes for unit tests
  preCheck = "ln -s source ../../${finalAttrs.pname}";
  pythonImportsCheck = [
    "example_robot_data"
  ];

  meta = with lib; {
    description = "Set of robot URDFs for benchmarking and developed examples.";
    homepage = "https://github.com/Gepetto/example-robot-data";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nim65s wegank ];
    platforms = platforms.unix;
  };
})
