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

buildPythonPackage (finalAttrs: {
  pname = "pymodbus";
  version = "3.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pymodbus-dev";
    repo = "pymodbus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wyelHxfzmoyqp+D6v4EqJK8fL4FOuYrV57xZROGuIsY=";
  };

  __darwinAllowLocalNetworking = true;

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
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  preCheck = ''
    pushd test
  '';

  postCheck = ''
    popd
  '';

  pythonImportsCheck = [ "pymodbus" ];

  disabledTests = [
    # Tests often hang
    "test_connected"
  ]
  ++ lib.optionals (lib.versionAtLeast aiohttp.version "3.9.0") [
    "test_split_serial_packet"
    "test_serial_poll"
    "test_simulator"
  ];

  disabledTestPaths = [
    # Don't test the examples
    "examples/"
  ];

  meta = {
    description = "Python implementation of the Modbus protocol";
    longDescription = ''
      Pymodbus is a full Modbus protocol implementation using twisted,
      torndo or asyncio for its asynchronous communications core. It can
      also be used without any third party dependencies if a more
      lightweight project is needed.
    '';
    homepage = "https://github.com/pymodbus-dev/pymodbus";
    changelog = "https://github.com/pymodbus-dev/pymodbus/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "pymodbus.simulator";
  };
})
