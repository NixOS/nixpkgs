{
  lib,
  fetchFromGitLab,
  buildPythonPackage,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-sql";
  version = "1.7.0";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "foss.heptapod.net";
    owner = "tryton";
    repo = "python-sql";
    tag = finalAttrs.version;
    hash = "sha256-JhMJEng6QftWBmJIC2pYlf9fkHHmSd3k0tSwr35MmVQ=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "sql" ];

  meta = {
    description = "Library to write SQL queries in a pythonic way";
    homepage = "https://foss.heptapod.net/tryton/python-sql";
    changelog = "https://foss.heptapod.net/tryton/python-sql/-/blob/${finalAttrs.src.tag}/CHANGELOG";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ johbo ];
  };
})
