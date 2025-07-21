{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pytestCheckHook,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "aiosqlite";
  version = "0.21.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "omnilib";
    repo = "aiosqlite";
    tag = "v${version}";
    hash = "sha256-3l/uR97WuLlkAEdogL9iYoXp89bsAcpH6XEtMELsX9o=";
  };

  build-system = [ flit-core ];

  dependencies = [ typing-extensions ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Tests are not pick-up automatically by the hook
  enabledTestPaths = [ "aiosqlite/tests/*.py" ];

  pythonImportsCheck = [ "aiosqlite" ];

  meta = with lib; {
    description = "Asyncio bridge to the standard sqlite3 module";
    homepage = "https://github.com/jreese/aiosqlite";
    changelog = "https://github.com/omnilib/aiosqlite/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
  };
}
