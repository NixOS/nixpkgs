{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, drf-extra-fields
}:

buildPythonPackage rec {
  pname = "netbox-documents";
  version = "0.6.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jasonyates";
    repo = "netbox-documents";
    rev = "v${version}";
    hash = "sha256-BQ33eJAp0Hnc77Mvaq9xAcDqz15fkdCwQ7Q46eOOmaI";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    drf-extra-fields
  ];

  # there are no tests
  doCheck = false;

  # also, we can't enable pythonImportsCheck probably because of the plugin system
  meta = {
    description = "Plugin designed to faciliate the storage of site, circuit, device type and device specific documents within NetBox";
    homepage = "https://github.com/jasonyates/netbox-documents";
    changelog = "https://github.com/jasonyates/netbox-documents/releases/tag/${src.rev}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ felbinger ];
  };
}
