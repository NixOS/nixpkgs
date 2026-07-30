{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "knx-frontend";
  version = "2026.7.23.145751";
  pyproject = true;

  # TODO: source build, uses yarn.lock
  src = fetchPypi {
    pname = "knx_frontend";
    inherit (finalAttrs) version;
    hash = "sha256-8BjMPjSMmw6jtDcsp0L8KrZG8aJR57dDX+dyZbmoenU=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "knx_frontend" ];

  # no tests
  doCheck = false;

  meta = {
    changelog = "https://github.com/XKNX/knx-frontend/releases/tag/${finalAttrs.version}";
    description = "Home Assistant Panel for managing the KNX integration";
    homepage = "https://github.com/XKNX/knx-frontend";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
