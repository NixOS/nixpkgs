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
<<<<<<< HEAD
  version = "3.11.4";
=======
  version = "3.11.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pymodbus-dev";
    repo = "pymodbus";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-Le/TJfDSvro9eMLOfY/il/0LSJ8orHSSjI7jaYdXaLs=";
=======
    hash = "sha256-2wOeghoi8FSk1II/0rid+ddRq7ceerH7ZeLcb+SSXKY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
  ++ lib.concatAttrValues optional-dependencies;
=======
  ++ lib.flatten (builtins.attrValues optional-dependencies);
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Python implementation of the Modbus protocol";
    longDescription = ''
      Pymodbus is a full Modbus protocol implementation using twisted,
      torndo or asyncio for its asynchronous communications core. It can
      also be used without any third party dependencies if a more
      lightweight project is needed.
    '';
    homepage = "https://github.com/pymodbus-dev/pymodbus";
    changelog = "https://github.com/pymodbus-dev/pymodbus/releases/tag/${src.tag}";
<<<<<<< HEAD
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
=======
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "pymodbus.simulator";
  };
}
