{
  lib,
  buildPythonPackage,
  cryptography,
  ddt,
  fetchFromGitHub,
  mock-services,
  pytestCheckHook,
  python-dateutil,
  requests,
  urllib3,
  requests-toolbelt,
  requests-unixsocket,
  setuptools,
  ws4py,
}:

buildPythonPackage rec {
  pname = "pylxd";
  version = "2.3.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "pylxd";
    tag = version;
    hash = "sha256-UbDkau3TLwFxWZxJGNF5hgtGn6JgVq5L2CvUgnb4IC8=";
  };

  pythonRelaxDeps = [ "urllib3" ];

  build-system = [ setuptools ];

  dependencies = [
    cryptography
    python-dateutil
    requests
    requests-toolbelt
    requests-unixsocket
    urllib3
    ws4py
  ];

  nativeCheckInputs = [
    ddt
    mock-services
    pytestCheckHook
  ];

  disabledTestPaths = [
    "integration"
    "migration"
  ];

  pythonImportsCheck = [ "pylxd" ];

  meta = {
    description = "Library for interacting with the LXD REST API";
    homepage = "https://pylxd.readthedocs.io/";
    changelog = "https://github.com/canonical/pylxd/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
