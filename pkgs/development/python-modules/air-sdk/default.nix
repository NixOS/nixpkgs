{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  poetry-core,
  python-dateutil,
  requests,
  faker,
  pytestCheckHook,
  requests-mock,
}:

buildPythonPackage {
  pname = "air-sdk";
  version = "2.21.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "air_sdk";
    # No git tags created for latest releases :(
    rev = "09e5865272a17b812ce03d034f4f08cbe6c9febd";
    hash = "sha256-ZWdxZ/KRHQfB1W2PuXy65kz6nC8lEYukyJLIreMc31A=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    python-dateutil
    requests
  ];

  pythonImportsCheck = [
    "air_sdk"
  ];

  nativeCheckInputs = [
    faker
    pytestCheckHook
    requests-mock
  ];

  disabledTestPaths = [
    # invalid use of mock library: https://github.com/NVIDIA/air_sdk/pull/3
    "tests/test_air_api.py"
    # typing errors: github.com/NVIDIA/air_sdk/issues/4
    "tests/tests_v2/test_endpoints/test_cloud_init.py"
    "tests/tests_v2/test_endpoints/test_interfaces.py"
    "tests/tests_v2/test_endpoints/test_links.py"
    "tests/tests_v2/test_endpoints/test_marketplace_demos.py"
    "tests/tests_v2/test_endpoints/test_nodes.py"
    "tests/tests_v2/test_endpoints/test_simulations.py"
  ];

  meta = {
    description = "Python SDK for interacting with NVIDIA Air";
    homepage = "https://pypi.org/project/air-sdk/";
    license = with lib.licenses; [
      asl20
      bsd3
      mit
    ];
    maintainers = with lib.maintainers; [ booxter ];
  };
}
