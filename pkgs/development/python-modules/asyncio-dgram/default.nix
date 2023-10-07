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
    rev = "refs/tagsv${version}";
    hash = "sha256-Eb/9JtgPT2yOlfnn5Ox8M0kcQhSlRCuX8+Rq6amki8Q=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  checkInputs = [
    pytest-asyncio
  ];

  # OSError: AF_UNIX path too long
  doCheck = !stdenv.isDarwin;

  disabledTests = [
    "test_protocol_pause_resume"
    # TypeError: socket type must be 2
    "test_from_socket_bad_socket"
  ];

  pythonImportsCheck = [
    "asyncio_dgram"
  ];

  meta = with lib; {
    description = "Python support for higher level Datagram";
    homepage = "https://github.com/jsbronder/asyncio-dgram";
    changelog = "https://github.com/jsbronder/asyncio-dgram/blob/v${version}/ChangeLog";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
