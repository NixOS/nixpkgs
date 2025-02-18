{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  multiprocess,
  pandas-stubs,
  pandas,
  poetry-core,
  pydantic,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pandantic";
  version = "1.0.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "wesselhuising";
    repo = "pandantic";
    tag = version;
    hash = "sha256-c108zoKBnjlELCDia8XSsdG8Exa/k7HKyRvcTocndss=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    multiprocess
    pandas
    pandas-stubs
    pydantic
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pandantic" ];

  meta = {
    description = "Module to enriche the Pydantic BaseModel class";
    homepage = "https://github.com/wesselhuising/pandantic";
    changelog = "https://github.com/wesselhuising/pandantic/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
