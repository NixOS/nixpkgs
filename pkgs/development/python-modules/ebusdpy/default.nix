{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "ebusdpy";
  version = "0.0.17";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-t6O/fOBrJuDYpCVnkL+hUzyqMoGKFj5UYNoD6ExikNM=";
  };

  build-system = [ setuptools ];

  # Package has no tests
  doCheck = false;

  pythonImportsCheck = [ "ebusdpy" ];

  meta = {
    description = "eBusd python integration library";
    homepage = "https://github.com/CrazYoshi/ebusdpy";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
