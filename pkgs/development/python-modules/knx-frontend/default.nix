{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "knx-frontend";
  version = "2024.8.6.211307";
  format = "pyproject";

  # TODO: source build, uses yarn.lock
  src = fetchPypi {
    pname = "knx_frontend";
    inherit version;
    hash = "sha256-WHZW3EXsLrbQZgmDRJK0yFUPgY2B9UgNfvenXHh2z9g=";
  };

  nativeBuildInputs = [ setuptools ];

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
