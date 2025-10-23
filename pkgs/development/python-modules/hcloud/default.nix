{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  python-dateutil,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "hcloud";
  version = "2.9.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MkYvojUd20ehps6whNcMg1hRgiTkS04Bl/LlwPZ62O8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    python-dateutil
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "hcloud" ];

  meta = with lib; {
    description = "Library for the Hetzner Cloud API";
    homepage = "https://github.com/hetznercloud/hcloud-python";
    changelog = "https://github.com/hetznercloud/hcloud-python/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ liff ];
  };
}
