{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  iconv,
  isPyPy,
  poetry-core,
  pytestCheckHook,
  python-dateutil,
  pytz,
  rustPlatform,
  time-machine,
  tzdata,
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

  build-system = [
    poetry-core
    rustPlatform.maturinBuildHook
    rustPlatform.cargoSetupHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ iconv ];

  dependencies = [
    python-dateutil
    tzdata
  ];

  pythonImportsCheck = [ "pendulum" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytz
  ]
  ++ lib.optional (!isPyPy) [ time-machine ];

  disabledTestPaths = [
    "tests/benchmarks"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # PermissionError: [Errno 1] Operation not permitted: '/etc/localtime'
    "tests/testing/test_time_travel.py"
  ];

  meta = with lib; {
    description = "Drop-in replacement for the standard datetime";
    homepage = "https://github.com/sdispater/pendulum";
    changelog = "https://github.com/sdispater/pendulum/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
  };
}
