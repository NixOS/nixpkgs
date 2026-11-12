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
  version = "0.22.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "omnilib";
    repo = "aiosqlite";
    tag = "v${version}";
    hash = "sha256-voOOFo1OwaRQ3JsDHlBrngP+8ajf0kTNKXJyOaJiTs4=";
  };

  build-system = [ flit-core ];

  dependencies = [ typing-extensions ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Tests are not pick-up automatically by the hook
  enabledTestPaths = [ "aiosqlite/tests/*.py" ];

  pythonImportsCheck = [ "aiosqlite" ];

  meta = {
    description = "Asyncio bridge to the standard sqlite3 module";
    homepage = "https://github.com/jreese/aiosqlite";
    changelog = "https://github.com/omnilib/aiosqlite/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
