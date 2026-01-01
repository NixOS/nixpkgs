{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  pythonOlder,
  isPyPy,

  # build-system
  poetry-core,
  rustPlatform,

  # native dependencies
  iconv,

  # dependencies
  importlib-resources,
  python-dateutil,
  time-machine,
  tzdata,

  # tests
  pytestCheckHook,
  pytz,
}:

buildPythonPackage rec {
  pname = "pendulum";
<<<<<<< HEAD
  version = "3.1.0-unstable-2025-10-28";
=======
  version = "3.1.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sdispater";
    repo = "pendulum";
<<<<<<< HEAD
    rev = "2982f25feaad2e58ad1530d3b53cc30fc1c82bd6";
    hash = "sha256-1ULvlWLZx3z5eGmWJfrN46x0ohJ+mAxipm6l6rykGPY=";
=======
    tag = version;
    hash = "sha256-ZjQaN5vT1+3UxwLNNsUmU4gSs6reUl90VSEumS0sEGY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  cargoRoot = "rust";
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    sourceRoot = "${src.name}/rust";
<<<<<<< HEAD
    hash = "sha256-Ozg+TW/woJsqmbmyDsgdMua3Lmnn+KBvBhd9kVik3XY=";
=======
    hash = "sha256-F5bCuvI8DcyeUTS7UyYBixCjuGFKGOXPw8HLVlYKuxA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    poetry-core
    rustPlatform.maturinBuildHook
    rustPlatform.cargoSetupHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ iconv ];

  propagatedBuildInputs = [
    python-dateutil
    tzdata
  ]
<<<<<<< HEAD
  ++ lib.optionals (!isPyPy) [
    time-machine
  ]
=======
  ++ lib.optional (!isPyPy) [ time-machine ]
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ++ lib.optionals (pythonOlder "3.9") [
    importlib-resources
  ];

  pythonImportsCheck = [ "pendulum" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytz
  ];

  disabledTestPaths = [
    "tests/benchmarks"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # PermissionError: [Errno 1] Operation not permitted: '/etc/localtime'
    "tests/testing/test_time_travel.py"
  ];

<<<<<<< HEAD
  meta = {
    description = "Python datetimes made easy";
    homepage = "https://github.com/sdispater/pendulum";
    changelog = "https://github.com/sdispater/pendulum/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "Python datetimes made easy";
    homepage = "https://github.com/sdispater/pendulum";
    changelog = "https://github.com/sdispater/pendulum/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
