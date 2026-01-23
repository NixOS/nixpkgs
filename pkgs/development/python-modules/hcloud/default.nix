{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  python-dateutil,
  requests,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "hcloud";
  version = "2.15.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-/Y5mjersmXo/6t5e3Te+BZpT5MvBT7AGCXZnUC737U0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    python-dateutil
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "hcloud" ];

  meta = {
    description = "Library for the Hetzner Cloud API";
    homepage = "https://github.com/hetznercloud/hcloud-python";
    changelog = "https://github.com/hetznercloud/hcloud-python/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ liff ];
  };
})
