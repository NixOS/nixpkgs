{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "asyncio-dgram";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "jsbronder";
    repo = pname;
    rev = "v${version}";
    sha256 = "1zkmjvq47zw2fsbnzhr5mh9rsazx0z1f8m528ash25jrxsza5crm";
  };

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
