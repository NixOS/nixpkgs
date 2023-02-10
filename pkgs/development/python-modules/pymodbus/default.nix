{ lib
, aiohttp
, asynctest
, buildPythonPackage
, click
, fetchFromGitHub
, mock
, prompt-toolkit
, pygments
, pyserial
, pyserial-asyncio
, pytest-asyncio
, pytest-rerunfailures
, pytest-xdist
, pytestCheckHook
, redis
, sqlalchemy
, tornado
, twisted
}:

buildPythonPackage rec {
  pname = "pymodbus";
  version = "3.1.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "pymodbus-dev";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-GHyDlt046v4KP9KQRnXH6F+3ikoCjbhVHEQuSdm99a8=";
  };

  # Twisted asynchronous version is not supported due to a missing dependency
  propagatedBuildInputs = [
    aiohttp
    click
    prompt-toolkit
    pygments
    pyserial
    pyserial-asyncio
    tornado
  ];

  nativeCheckInputs = [
    asynctest
    mock
    pytest-asyncio
    pytest-rerunfailures
    pytest-xdist
    pytestCheckHook
    redis
    sqlalchemy
    twisted
  ];

  pytestFlagsArray = [
    "--reruns" "3" # Racy socket tests
  ];

  pythonImportsCheck = [ "pymodbus" ];

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
