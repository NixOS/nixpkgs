{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, isPyPy

# build-system
, poetry-core
, rustPlatform

# native dependencies
, iconv

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
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sdispater";
    repo = "pendulum";
    rev = "refs/tags/${version}";
    hash = "sha256-v0kp8dklvDeC7zdTDOpIbpuj13aGub+oCaYz2ytkEpI=";
  };

  postPatch = ''
    substituteInPlace rust/Cargo.lock \
      --replace "3.0.0-beta-1" "3.0.0"
  '';

  cargoRoot = "rust";
  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    sourceRoot = "source/rust";
    name = "${pname}-${version}";
    hash = "sha256-6fw0KgnPIMfdseWcunsGjvjVB+lJNoG3pLDqkORPJ0I=";
    postPatch = ''
      substituteInPlace Cargo.lock \
        --replace "3.0.0-beta-1" "3.0.0"
    '';
  };

  nativeBuildInputs = [
    poetry-core
    rustPlatform.maturinBuildHook
    rustPlatform.cargoSetupHook
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    iconv
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
  ] ++ lib.optionals stdenv.isDarwin [
    # PermissionError: [Errno 1] Operation not permitted: '/etc/localtime'
    "tests/testing/test_time_travel.py"
  ];

  meta = with lib; {
    description = "Python datetimes made easy";
    homepage = "https://github.com/sdispater/pendulum";
    changelog = "https://github.com/sdispater/pendulum/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
