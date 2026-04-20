{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "asyncio-dgram";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jsbronder";
    repo = "asyncio-dgram";
    tag = "v${finalAttrs.version}";
    hash = "sha256-08XQHx+ArduVdkK5ZYq2lL2OWF9CvdSWcNLfc7ey2wI=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  # OSError: AF_UNIX path too long
  doCheck = !stdenv.hostPlatform.isDarwin;

  disabledTests = [
    "test_protocol_pause_resume"
    # TypeError: socket type must be 2
    "test_from_socket_bad_socket"
  ];

  pythonImportsCheck = [ "asyncio_dgram" ];

  meta = {
    description = "Python support for higher level Datagram";
    homepage = "https://github.com/jsbronder/asyncio-dgram";
    changelog = "https://github.com/jsbronder/asyncio-dgram/blob/v${finalAttrs.src.tag}/ChangeLog";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
})
