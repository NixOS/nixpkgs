{
  lib,
  buildPythonPackage,
  certifi,
  cryptography,
  docker,
  fetchFromGitHub,
  flit-core,
  podman,
  pycryptodome,
  pytestCheckHook,
  python-dateutil,
  typing-extensions,
  urllib3,
}:

buildPythonPackage rec {
  pname = "nethsm";
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Nitrokey";
    repo = "nethsm-sdk-py";
    tag = "v${version}";
    hash = "sha256-wqnyI6QmsBfQW7NbJrk92Ufw0+IFmc8/0ZsUp5XswYw=";
  };

  pythonRelaxDeps = true;

  build-system = [ flit-core ];

  dependencies = [
    certifi
    cryptography
    python-dateutil
    typing-extensions
    urllib3
  ];

  nativeCheckInputs = [
    docker
    podman
    pycryptodome
    pytestCheckHook
  ];

  pythonImportsCheck = [ "nethsm" ];

  disabledTestPaths = [
    # Tests require a running Docker instance
    "tests/test_nethsm_config.py"
    "tests/test_nethsm_keys.py"
    "tests/test_nethsm_namespaces.py"
    "tests/test_nethsm_other.py"
    "tests/test_nethsm_system.py"
    "tests/test_nethsm_users.py"
  ];

  meta = with lib; {
    description = "Client-side Python SDK for NetHSM";
    homepage = "https://github.com/Nitrokey/nethsm-sdk-py";
    changelog = "https://github.com/Nitrokey/nethsm-sdk-py/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ frogamic ];
  };
}
