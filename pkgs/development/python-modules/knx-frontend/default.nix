{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "knx-frontend";
  version = "2025.10.17.202411";
  pyproject = true;

  # TODO: source build, uses yarn.lock
  src = fetchPypi {
    pname = "knx_frontend";
    inherit version;
    hash = "sha256-nD56FfraKuT4H/Mqw6o2lP3xP4kHAGof369UJdJeT6w=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "knx_frontend" ];

  # no tests
  doCheck = false;

  meta = with lib; {
    changelog = "https://github.com/XKNX/knx-frontend/releases/tag/${version}";
    description = "Home Assistant Panel for managing the KNX integration";
    homepage = "https://github.com/XKNX/knx-frontend";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
