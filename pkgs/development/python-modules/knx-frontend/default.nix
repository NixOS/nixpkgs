{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "knx-frontend";
  version = "2025.10.26.81530";
  pyproject = true;

  # TODO: source build, uses yarn.lock
  src = fetchPypi {
    pname = "knx_frontend";
    inherit version;
    hash = "sha256-8JRiKgltnY8aPlcVP4yr1/z9mJYG0Axr1KnXPK9XgLI=";
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
