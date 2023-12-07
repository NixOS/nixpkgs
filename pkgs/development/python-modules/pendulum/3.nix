{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, isPyPy

# build-system
, poetry-core
, rustPlatform

# dependencies
, backports-zoneinfo
, importlib-resources
, python-dateutil
, time-machine
, tzdata

# tests
, pytestCheckHook
, pytz
}:

buildPythonPackage rec {
  pname = "pendulum";
  version = "3.0.0b1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sdispater";
    repo = "pendulum";
    rev = "refs/tags/${version}";
    hash = "sha256-11W22RpoYUcL9Nya32HRX4Jdo4L9XP2Zftevc+7eFzw=";
  };

  cargoRoot = "rust";
  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    sourceRoot = "source/rust";
    name = "${pname}-${version}";
    hash = "sha256-qyyPR4a+IHrRSZzOZaW+DXGpOTyFcEVu/+Mt5QlQFqw=";
  };

  nativeBuildInputs = [
    poetry-core
    rustPlatform.maturinBuildHook
    rustPlatform.cargoSetupHook
  ];

  propagatedBuildInputs = [
    python-dateutil
    tzdata
  ] ++ lib.optional (!isPyPy) [
    time-machine
  ] ++ lib.optionals (pythonOlder "3.9") [
    backports-zoneinfo
    importlib-resources
  ];

  pythonImportsCheck = [
    "pendulum"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytz
  ];

  disabledTestPaths = [
    "tests/benchmarks"
  ];

  meta = with lib; {
    description = "Python datetimes made easy";
    homepage = "https://github.com/sdispater/pendulum";
    changelog = "https://github.com/sdispater/pendulum/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
