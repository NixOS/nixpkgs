{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "co2signal";
  version = "0.4.2";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "CO2Signal";
    hash = "sha256-8YdYbknLICRrZloGUZuscv5e1LIDZBcCPKZs6EMaNuo=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];
  # Modules has no tests
  doCheck = false;

  pythonImportsCheck = [ "CO2Signal" ];

  meta = {
    description = "Package to access the CO2 Signal API";
    homepage = "https://github.com/danielsjf/CO2Signal";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ plabadens ];
  };
})
