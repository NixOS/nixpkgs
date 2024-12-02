{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  dparse,
  packaging,
  pydantic,
  ruamel-yaml,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "safety-schemas";
  version = "0.0.9";
  pyproject = true;

  src = fetchPypi {
    pname = "safety_schemas";
    inherit version;
    hash = "sha256-IwRPiKohITmAsA5gAs9WIp4e/Ctsvd4+kPx4HKa7whc=";
  };

  build-system = [ hatchling ];

  pythonRelaxDeps = [ "dparse" ];

  dependencies = [
    dparse
    packaging
    pydantic
    ruamel-yaml
    typing-extensions
  ];

  pythonImportsCheck = [ "safety_schemas" ];

  # upstream has no tests
  doCheck = false;

  meta = {
    description = "Schemas for Safety CLI";
    homepage = "https://pypi.org/project/safety-schemas/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
