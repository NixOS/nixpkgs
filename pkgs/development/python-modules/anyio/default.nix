{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, idna
, sniffio
, typing-extensions
, curio
, hypothesis
, pytestCheckHook
, trio
, trustme
, uvloop
}:

buildPythonPackage rec {
  pname = "anyio";
  version = "2.1.0";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "agronholm";
    repo = pname;
    rev = version;
    sha256 = "0k5c4a7xcbiyah8rgrfh2hwj3l3a9al7rh2lyz9ip4rr1hwnqvaf";
  };

  propagatedBuildInputs = [
    idna
    sniffio
  ] ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  checkInputs = [
    curio
    hypothesis
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
