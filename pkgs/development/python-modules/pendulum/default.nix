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
  version = "3.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sdispater";
    repo = "pendulum";
    tag = version;
    hash = "sha256-ZjQaN5vT1+3UxwLNNsUmU4gSs6reUl90VSEumS0sEGY=";
  };

  cargoRoot = "rust";
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    sourceRoot = "${src.name}/rust";
    hash = "sha256-F5bCuvI8DcyeUTS7UyYBixCjuGFKGOXPw8HLVlYKuxA=";
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
  ++ lib.optional (!isPyPy) [ time-machine ]
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

  meta = with lib; {
    description = "Python datetimes made easy";
    homepage = "https://github.com/sdispater/pendulum";
    changelog = "https://github.com/sdispater/pendulum/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
  };
}
