{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  rustPlatform,

  # dependencies
  python-dateutil,
  tzdata,

  # tests
  pytestCheckHook,
  time-machine,
}:

buildPythonPackage (finalAttrs: {
  pname = "pendulum";
  version = "3.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-pendulum";
    repo = "pendulum";
    tag = finalAttrs.version;
    hash = "sha256-BZZhSvO9G9EIY3yEVmufZzPqIFfVlTZkPqJowhHCjdY=";
  };

  cargoRoot = "rust";
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    sourceRoot = "${finalAttrs.src.name}/rust";
    hash = "sha256-Mkd5/UtxGppysFX3WoYtYqatHW4J3q7iH9MBN/jSfZM=";
  };

  nativeBuildInputs = [
    rustPlatform.maturinBuildHook
    rustPlatform.cargoSetupHook
  ];

  dependencies = [
    python-dateutil
    tzdata
  ];

  pythonImportsCheck = [ "pendulum" ];

  nativeCheckInputs = [
    pytestCheckHook
    time-machine
  ];

  disabledTests = [
    # broke with tzdata 2026.6
    "test_instance_with_aware_datetime_any_tzinfo"
  ];

  disabledTestPaths = [
    "tests/benchmarks"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # PermissionError: [Errno 1] Operation not permitted: '/etc/localtime'
    "tests/testing/test_time_travel.py"
  ];

  meta = {
    description = "Python datetimes made easy";
    homepage = "https://github.com/python-pendulum/pendulum";
    changelog = "https://github.com/python-pendulum/pendulum/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
