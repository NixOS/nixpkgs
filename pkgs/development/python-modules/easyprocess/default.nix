{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAtrrs: {
  pname = "easyprocess";
  version = "1.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "EasyProcess";
    inherit (finalAtrrs) version;
    hash = "sha256-iFiYMCpXqrlIlz6LXTKkIpOSufstmGqx1P/VkOW6kOw=";
  };

  build-system = [
    setuptools
  ];

  # No tests
  doCheck = false;

  meta = {
    description = "Easy to use python subprocess interface";
    homepage = "https://github.com/ponty/EasyProcess";
    license = lib.licenses.bsdOriginal;
    maintainers = with lib.maintainers; [ layus ];
  };
})
