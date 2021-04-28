{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, idna
, sniffio
, typing-extensions
, hypothesis
, pytest-mock
, pytestCheckHook
, trio
, trustme
, uvloop
}:

buildPythonPackage rec {
  pname = "anyio";
  version = "3.1.0";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "agronholm";
    repo = pname;
    rev = version;
    sha256 = "17zc8wxkp22xn84dqw2wbmfx8h9j3bv4why8zdn9swkv0c0r426d";
  };

  propagatedBuildInputs = [
    idna
    sniffio
  ] ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  checkInputs = [
    hypothesis
    pytest-mock
    pytestCheckHook
    trio
    trustme
    uvloop
  ];

  pytestFlagsArray = [
    # lots of DNS lookups
    "--ignore=tests/test_sockets.py"
  ] ++ lib.optionals stdenv.isDarwin [
    # darwin sandboxing limitations
    "--ignore=tests/streams/test_tls.py"
  ];

  pythonImportsCheck = [ "anyio" ];

  meta = with lib; {
    description = "High level compatibility layer for multiple asynchronous event loop implementations on Python";
    homepage = "https://github.com/agronholm/anyio";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
