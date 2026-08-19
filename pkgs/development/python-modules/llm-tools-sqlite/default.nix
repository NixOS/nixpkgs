{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  llm,
  llm-tools-sqlite,
  llm-echo,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "llm-tools-sqlite";
  version = "0.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "llm-tools-sqlite";
    tag = finalAttrs.version;
    hash = "sha256-VAmK4cXzZWTWCU92TwMdhNJPvYPZ88t5BZe8vo60SZY=";
  };

  patches = [
    ./fix-test.patch
  ];

  build-system = [ setuptools ];

  dependencies = [ llm ];

  nativeCheckInputs = [
    llm-echo
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "llm_tools_sqlite" ];

  passthru.tests = llm.mkPluginTest llm-tools-sqlite;

  meta = {
    description = "LLM tools for running queries against SQLite";
    homepage = "https://github.com/simonw/llm-tools-sqlite";
    changelog = "https://github.com/simonw/llm-tools-sqlite/releases/tag/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ philiptaron ];
  };
})
