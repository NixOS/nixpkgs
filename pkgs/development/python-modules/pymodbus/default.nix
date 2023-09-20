{ lib
, aiohttp
, buildPythonPackage
, click
, fetchFromGitHub
, mock
, prompt-toolkit
, pygments
, pyserial
, pytest-asyncio
, pytest-xdist
, pytestCheckHook
, redis
, sqlalchemy
, twisted
, typer
}:

buildPythonPackage rec {
  pname = "pymodbus";
  version = "3.5.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "pymodbus-dev";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-FOmR9yqLagqcsAVxqHxziEcnZ5M9QpL2qIp8x2gS2PU=";
  };

  passthru.optional-dependencies = {
    repl = [
      aiohttp
      typer
      prompt-toolkit
      pygments
      click
    ] ++ typer.optional-dependencies.all;
    serial = [
      pyserial
    ];
  };

  nativeCheckInputs = [
    mock
    pytest-asyncio
    pytest-xdist
    pytestCheckHook
    redis
    sqlalchemy
    twisted
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  preCheck = ''
    pushd test
  '';

  postCheck = ''
    popd
  '';

  pythonImportsCheck = [
    "pymodbus"
  ];

  disabledTests = [
    # Tests often hang
    "test_connected"
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
  };
}
