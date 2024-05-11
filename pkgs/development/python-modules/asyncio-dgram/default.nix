{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "asyncio-dgram";
  version = "2.2.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jsbronder";
    repo = "asyncio-dgram";
    rev = "refs/tags/v${version}";
    hash = "sha256-Eb/9JtgPT2yOlfnn5Ox8M0kcQhSlRCuX8+Rq6amki8Q=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  # OSError: AF_UNIX path too long
  doCheck = !stdenv.isDarwin;

  disabledTests = [
    "test_protocol_pause_resume"
    # TypeError: socket type must be 2
    "test_from_socket_bad_socket"
  ];

  pythonImportsCheck = [ "asyncio_dgram" ];

  meta = with lib; {
    description = "Python support for higher level Datagram";
    homepage = "https://github.com/jsbronder/asyncio-dgram";
    changelog = "https://github.com/jsbronder/asyncio-dgram/blob/v${version}/ChangeLog";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
