{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pydantic,
  typer,
  pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "countryinfo";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "porimol";
    repo = "countryinfo";
    tag = "v${version}";
    hash = "sha256-Y4nJnjXg8raJx2f00DFMktdcWoLO09wqTFK6Fc8RKSI=";
  };

  build-system = [ poetry-core ];

  patches = [ ./fix-pyproject-file.patch ];

  dependencies = [
    pydantic
    typer
  ];

  pythonRelaxDeps = [ "typer" ];

  pythonImportsCheck = [ "countryinfo" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    homepage = "https://github.com/porimol/countryinfo";
    description = "Data about countries, ISO info and states/provinces within them";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      cizniarova
    ];
  };
}
