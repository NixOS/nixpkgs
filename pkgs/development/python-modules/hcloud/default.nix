{
  lib,
  buildPythonPackage,
  fetchPypi,
  future,
  mock,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "hcloud";
  version = "2.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cDyy2x1JINthvhuzQdwgMcykGrypnTkk4rJBk1WQ1HQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    future
    requests
    python-dateutil
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "hcloud" ];

  meta = with lib; {
    description = "Library for the Hetzner Cloud API";
    homepage = "https://github.com/hetznercloud/hcloud-python";
    changelog = "https://github.com/hetznercloud/hcloud-python/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ liff ];
  };
}
