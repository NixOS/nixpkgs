{ lib
, asynctest
, buildPythonPackage
, fetchFromGitHub
, mock
, pyserial
, pyserial-asyncio
, pytestCheckHook
, pythonOlder
, redis
, sqlalchemy
, tornado
, twisted
}:

buildPythonPackage rec {
  pname = "pymodbus";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "riptideio";
    repo = pname;
    rev = "v${version}";
    sha256 = "0x0dv02shcc2yxxm9kvcbhip111sna74dvcfssxdzzy967vnq76v";
  };

  # Twisted asynchronous version is not supported due to a missing dependency
  propagatedBuildInputs = [
    pyserial
    pyserial-asyncio
    tornado
  ];

  checkInputs = [
    asynctest
    mock
    pyserial-asyncio
    pytestCheckHook
    redis
    sqlalchemy
    tornado
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
