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
  version = "0.0.16";
  pyproject = true;

  src = fetchPypi {
    pname = "safety_schemas";
    inherit version;
    hash = "sha256-O7BNEb1LXMefn6GDxlimqM+CepzuxEOl/6bu04pQok4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace hatchling==1.26.3 hatchling
  '';

  build-system = [ hatchling ];

  pythonRelaxDeps = [
    "pydantic"
  ];

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
