{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pytestCheckHook,
  pythonOlder,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "aiosqlite";
  version = "0.21.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "omnilib";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-3l/uR97WuLlkAEdogL9iYoXp89bsAcpH6XEtMELsX9o=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [ typing-extensions ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Tests are not pick-up automatically by the hook
  pytestFlagsArray = [ "aiosqlite/tests/*.py" ];

  pythonImportsCheck = [ "aiosqlite" ];

  meta = with lib; {
    description = "Asyncio bridge to the standard sqlite3 module";
    homepage = "https://github.com/jreese/aiosqlite";
    changelog = "https://github.com/omnilib/aiosqlite/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
  };
}
