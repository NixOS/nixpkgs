{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  pythonRelaxDepsHook,
  poetry-core,
  dacite,
  diskcache,
  jsonschema,
  pandas,
  pyarrow,
}:

buildPythonPackage rec {
  pname = "datashaper";
  version = "0.0.49";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Bb+6WWRHSmK91SWew/oBc9AeNlIItqSv9OoOYwlqdTM=";
  };

  build-system = [ poetry-core ];

  nativeBuildInputs = [ pythonRelaxDepsHook ];

  pythonRelaxDeps = [ "pyarrow" ];

  dependencies = [
    dacite
    diskcache
    jsonschema
    pandas
    pyarrow
  ];

  pythonImportsCheck = [ "datashaper" ];

  # pypi tarball has no tests
  doCheck = false;

  meta = {
    description = "Collection of utilities for doing lightweight data wrangling";
    homepage = "https://github.com/microsoft/datashaper/tree/main/python/datashaper";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
