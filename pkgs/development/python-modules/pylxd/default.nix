{
  lib,
  buildPythonPackage,
  cryptography,
  ddt,
  fetchFromGitHub,
  mock-services,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  requests,
  urllib3,
  requests-toolbelt,
  requests-unixsocket,
  setuptools,
  ws4py,
}:

buildPythonPackage rec {
  pname = "pylxd";
  version = "2.3.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "canonica";
    repo = "pylxd";
    rev = "refs/tags/${version}";
    hash = "sha256-Q4GMz7HFpJNPYlYgLhE0a7mVCwNpdbw4XVcUGQ2gUJ0=";
  };

  pythonRelaxDeps = [ "urllib3" ];

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
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

  meta = with lib; {
    description = "Library for interacting with the LXD REST API";
    homepage = "https://pylxd.readthedocs.io/";
    changelog = "https://github.com/canonical/pylxd/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
