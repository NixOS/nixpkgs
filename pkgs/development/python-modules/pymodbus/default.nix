{
  lib,
  aiohttp,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  prompt-toolkit,
  pygments,
  pymodbus-repl,
  pyserial,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-xdist,
  pytestCheckHook,
  redis,
  setuptools,
  sqlalchemy,
  twisted,
  typer,
}:

buildPythonPackage rec {
  pname = "pymodbus";
  version = "3.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pymodbus-dev";
    repo = "pymodbus";
    tag = "v${version}";
    hash = "sha256-O64r8/3AGZYr449FANo3wQCUiIJkIjN5eQ+VoTrvUHo=";
  };

  build-system = [ setuptools ];

  optional-dependencies = {
    repl = [ pymodbus-repl ];
    serial = [ pyserial ];
    simulator = [ aiohttp ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytest-xdist
    pytestCheckHook
    redis
    sqlalchemy
    twisted
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  preCheck = ''
    pushd test
  '';

  postCheck = ''
    popd
  '';

  pythonImportsCheck = [ "pymodbus" ];

  disabledTests =
    [
      # Tests often hang
      "test_connected"
    ]
    ++ lib.optionals (lib.versionAtLeast aiohttp.version "3.9.0") [
      "test_split_serial_packet"
      "test_serial_poll"
      "test_simulator"
    ];

  meta = with lib; {
    description = "Python implementation of the Modbus protocol";
    longDescription = ''
      Pymodbus is a full Modbus protocol implementation using twisted,
      torndo or asyncio for its asynchronous communications core. It can
      also be used without any third party dependencies if a more
      lightweight project is needed.
    '';
    homepage = "https://github.com/pymodbus-dev/pymodbus";
    changelog = "https://github.com/pymodbus-dev/pymodbus/releases/tag/v${version}";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "pymodbus.simulator";
  };
}
