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
, pytestCheckHook
, redis
, sqlalchemy
, tornado
, twisted
}:

buildPythonPackage rec {
  pname = "pymodbus";
  version = "2.5.3";

  src = fetchFromGitHub {
    owner = "riptideio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-pf1TU/imBqNVYdG4XX8fnma8O8kQHuOHu6DT3E/PUk4=";
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

  checkInputs = [
    asynctest
    mock
    pytestCheckHook
    redis
    sqlalchemy
    twisted
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
    homepage = "https://github.com/riptideio/pymodbus";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
