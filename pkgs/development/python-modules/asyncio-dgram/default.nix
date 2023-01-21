{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "asyncio-dgram";
  version = "2.1.2";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "jsbronder";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Eb/9JtgPT2yOlfnn5Ox8M0kcQhSlRCuX8+Rq6amki8Q=";
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  # OSError: AF_UNIX path too long
  doCheck = !stdenv.isDarwin;

  disabledTests = [
    "test_protocol_pause_resume"
  ];

  pythonImportsCheck = [
    "asyncio_dgram"
  ];

  meta = with lib; {
    description = "Python support for higher level Datagram";
    homepage = "https://github.com/jsbronder/asyncio-dgram";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
