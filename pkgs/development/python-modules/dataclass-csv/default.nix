{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pyprojectVersionPatchHook,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "dataclass-csv";
  version = "1.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dfurtado";
    repo = "dataclass-csv";
    tag = finalAttrs.version;
    hash = "sha256-hDnuPg5xniybR2J91KnJxSlOI+dWzUPQJtYKfqsNCvw=";
  };

  build-system = [ hatchling ];

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dataclass_csv" ];

  meta = {
    description = "Map CSV data into dataclasses";
    homepage = "https://github.com/dfurtado/dataclass-csv";
    changelog = "https://github.com/dfurtado/dataclass-csv/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ theobori ];
  };
})
