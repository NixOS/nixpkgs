{ lib
, aiohttp
, asynctest
, buildPythonPackage
, click
, fetchFromGitHub
, mock
, prompt_toolkit
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
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "riptideio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-b85jfBZfMZtqtmID+tGBgOe9o0BbmBH83UV71lYAI5c=";
  };

  # Twisted asynchronous version is not supported due to a missing dependency
  propagatedBuildInputs = [
    aiohttp
    click
    prompt_toolkit
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
