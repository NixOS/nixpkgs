{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "asyncio-dgram";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "jsbronder";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ibyphncb3d8vrs3yk8j6l1smmnibizx9k1vir2njhi09r57h9mx";
  };

  # OSError: AF_UNIX path too long
  doCheck = !stdenv.isDarwin;

  checkInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  disabledTests = [ "test_protocol_pause_resume" ];

  pythonImportsCheck = [ "asyncio_dgram" ];

  meta = with lib; {
    description = "Python support for higher level Datagram";
    homepage = "https://github.com/jsbronder/asyncio-dgram";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
