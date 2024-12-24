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
    sourceRoot = "${src.name}/rust";
    name = "${pname}-${version}";
    hash = "sha256-6fw0KgnPIMfdseWcunsGjvjVB+lJNoG3pLDqkORPJ0I=";
    postPatch = ''
      substituteInPlace Cargo.lock \
        --replace "3.0.0-beta-1" "3.0.0"
    '';
  };

  patches = [
    # fix build on 32bit
    # https://github.com/sdispater/pendulum/pull/842
    (fetchpatch {
      url = "https://github.com/sdispater/pendulum/commit/6f2fcb8b025146ae768a5889be4a437fbd3156d6.patch";
      hash = "sha256-47591JvpADxGQT2q7EYWHfStaiWyP7dt8DPTq0tiRvk=";
    })
  ];

  nativeBuildInputs = [
    poetry-core
    rustPlatform.maturinBuildHook
    rustPlatform.cargoSetupHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ iconv ];

  propagatedBuildInputs =
    [
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

  disabledTestPaths =
    [ "tests/benchmarks" ]
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
