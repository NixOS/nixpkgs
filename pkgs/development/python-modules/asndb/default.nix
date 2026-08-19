{
  lib,
  blasthttp,
  buildPythonPackage,
  cachetools,
  fetchPypi,
  nix-update-script,
  radixtarget,
  setuptools,
  typer,
}:

buildPythonPackage (finalAttrs: {
  pname = "asndb";
  version = "1.1.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-Q1qXQepm1ouBfJwQVHKfiMPV66lLlsqZGxWa1Asj0Mo=";
  };

  build-system = [ setuptools ];

  dependencies = [
    blasthttp
    cachetools
    radixtarget
    typer
  ];

  # Tests require network access
  doCheck = false;

  pythonImportsCheck = [ "asndb" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Library for looking up ASNs by IP or AS number";
    homepage = "https://pypi.org/project/asndb";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
})
