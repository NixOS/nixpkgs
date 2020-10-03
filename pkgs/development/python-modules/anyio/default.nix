{ lib
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
  version = "2.0.2";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "agronholm";
    repo = pname;
    rev = version;
    sha256 = "06nazfrm2sclp3lpgsn9wl8vmqxvx36s3gr2gnqz3zhjpf3glkxv";
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
  ];

  pythonImportsCheck = [ "anyio" ];

  meta = with lib; {
    description = "High level compatibility layer for multiple asynchronous event loop implementations on Python";
    homepage = "https://github.com/agronholm/anyio";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
