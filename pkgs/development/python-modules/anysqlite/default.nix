{
  lib,
  anyio,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-fancy-pypi-readme,
  hatchling,
  pytestCheckHook,
  trio,
}:

buildPythonPackage rec {
  pname = "anysqlite";
  version = "0.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "karpetrosyan";
    repo = "anysqlite";
    tag = "v${version}";
    hash = "sha256-6kNN6kjkMHVNneMq/8zQxqMIXUxH/+eWLX8XhoHqFRU=";
  };

  nativeBuildInputs = [
    hatch-fancy-pypi-readme
    hatchling
  ];

  propagatedBuildInputs = [ anyio ];

  nativeCheckInputs = [
    pytestCheckHook
    trio
  ];

  pythonImportsCheck = [ "anysqlite" ];

  meta = {
    description = "Sqlite3 for asyncio and trio";
    homepage = "https://github.com/karpetrosyan/anysqlite";
    changelog = "https://github.com/karpetrosyan/anysqlite/blob/${version}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
}
