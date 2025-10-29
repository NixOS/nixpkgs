{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytest-asyncio,
  pytestCheckHook,
  stdenv,
  syrupy,
}:

buildPythonPackage rec {
  pname = "pyheos";
  version = "1.0.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "andrewsayre";
    repo = "pyheos";
    tag = version;
    hash = "sha256-CqUeDIHRD+stIVr9nMqfKUExVHPq8gbIzsZg8U36E7I=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    syrupy
  ];

  disabledTests = [
    # accesses network
    "test_connect_timeout"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # OSError: could not bind on any address out of [('127.0.0.2', 1255)]
    "test_failover"
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "pyheos" ];

  meta = {
    changelog = "https://github.com/andrewsayre/pyheos/releases/tag/${src.tag}";
    description = "Async python library for controlling HEOS devices through the HEOS CLI Protocol";
    homepage = "https://github.com/andrewsayre/pyheos";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
