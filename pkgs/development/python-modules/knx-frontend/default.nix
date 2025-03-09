{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "knx-frontend";
  version = "2025.1.30.194235";
  pyproject = true;

  # TODO: source build, uses yarn.lock
  src = fetchPypi {
    pname = "knx_frontend";
    inherit version;
    hash = "sha256-P3KUpmltw7xX/6xq9RMFlP8UMDp2/ynvVCkK3rvwzk0=";
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
