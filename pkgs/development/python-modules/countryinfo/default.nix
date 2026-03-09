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
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "porimol";
    repo = "countryinfo";
    tag = "v${version}";
    hash = "sha256-PE9XiVH6XE+OSySL5Lo0MPWyIEX8xgeHQB7MttMfmz8=";
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
