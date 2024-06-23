{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  oldest-supported-numpy,
  setuptools,
  ansitable,
  matplotlib,
  numpy,
  pgraph-python,
  progress,
  rtb-data,
  scipy,
  spatialgeometry,
  spatialmath-python,
  swift-sim,
  typing-extensions,
  pybullet,
  bdsim,
  black,
  flake8,
  pytest,
  pytest-cov,
  pyyaml,
  qpsolvers,
  quadprog,
  sympy,
  callPackage,
}:

buildPythonPackage rec {
  pname = "roboticstoolbox-python";
  version = "1.1.1";
  pyproject = true;

  outputs = [
    "out"
    "testsout"
  ];

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "roboticstoolbox_python";
    inherit version;
    hash = "sha256-JhX4CHhLkZB5J6tA45zC4024mlPnGhS0D5c3VhIuqeQ=";
  };

  nativeBuildInputs = [
    oldest-supported-numpy
    setuptools
  ];

  propagatedBuildInputs = [
    ansitable
    matplotlib
    numpy
    pgraph-python
    progress
    rtb-data
    scipy
    spatialgeometry
    spatialmath-python
    swift-sim
    typing-extensions
  ];

  passthru.optional-dependencies = {
    collision = [ pybullet ];
    dev = [
      bdsim
      black
      flake8
      pybullet
      pytest
      pytest-cov
      pyyaml
      qpsolvers
      quadprog
      sympy
    ];
  };

  postInstall = ''
    mkdir $testsout
    cp -R tests $testsout/tests
  '';

  # Tests have been put in their own derivation as there is a circular
  # dependency between spatialgeometry and roboticstoolbox-python. Check in
  # passthru.tests.pytest for the tests.
  doCheck = false;

  passthru.tests = {
    pytest = callPackage ./tests.nix { };
  };

  pythonImportsCheck = [ "roboticstoolbox" ];

  meta = with lib; {
    description = "A Python library for robotics education and research";
    homepage = "https://pypi.org/project/roboticstoolbox-python/";
    license = licenses.mit;
    maintainers = with maintainers; [
      djacu
      a-camarillo
    ];
  };
}
