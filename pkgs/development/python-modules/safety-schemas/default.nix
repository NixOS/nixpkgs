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
  version = "0.0.2";
  pyproject = true;

  src = fetchPypi {
    pname = "safety_schemas";
    inherit version;
    hash = "sha256-fRsEDsBkgPBc/2tF6nqT4JyJQt+GT7DQHd62fDI8+ow=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  pythonRelaxDeps = [ "dparse" ];

  propagatedBuildInputs = [
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
