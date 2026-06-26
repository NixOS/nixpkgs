{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  rustPlatform,

  # native dependencies
  iconv,

  # dependencies
  python-dateutil,
  tzdata,

  # tests
  pytestCheckHook,
  time-machine,
}:

buildPythonPackage (finalAttrs: {
  pname = "pendulum";
  version = "3.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sdispater";
    repo = "pendulum";
    tag = finalAttrs.version;
    hash = "sha256-zpBymeYhCy+yu6RPhOuN5xOVk6928hd3+oRsfiBPPuY=";
  };

  cargoRoot = "rust";
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    sourceRoot = "${finalAttrs.src.name}/rust";
    hash = "sha256-tC65lxI561ygOhBFujWzGk32XiQH6QB42nqboWSfQrg=";
  };

  nativeBuildInputs = [
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
    time-machine
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
    homepage = "https://github.com/sdispater/pendulum";
    changelog = "https://github.com/sdispater/pendulum/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
