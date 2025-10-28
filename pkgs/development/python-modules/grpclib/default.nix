{
  lib,
  buildPythonPackage,
  certifi,
  faker,
  fetchFromGitHub,
  fetchpatch,
  googleapis-common-protos,
  h2,
  multidict,
  pytest-asyncio_0,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "grpclib";
  version = "0.4.8";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "vmagamedov";
    repo = "grpclib";
    tag = "v${version}";
    hash = "sha256-Z+DMwGMUxNTQ7ABd4q/FgMHEZ/NCOtst+6QfQJm3jVU=";
  };

  patches = [
    # https://github.com/vmagamedov/grpclib/pull/209
    (fetchpatch {
      name = "replace-async-timeout-with-asyncio-timeout-patch";
      url = "https://github.com/vmagamedov/grpclib/commit/36b23ce3ca3f1742e39b50f939d13cd08b4f28ac.patch";
      hash = "sha256-3ztLBOFpTK8CFIp8a6suhWXY5kIBCBRWBX/oAyYU4yI=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
    h2
    multidict
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio_0
    faker
    googleapis-common-protos
    certifi
  ];

  pythonImportsCheck = [ "grpclib" ];

  meta = with lib; {
    description = "Pure-Python gRPC implementation for asyncio";
    homepage = "https://github.com/vmagamedov/grpclib";
    changelog = "https://github.com/vmagamedov/grpclib/blob/v${version}/docs/changelog/index.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nikstur ];
  };
}
