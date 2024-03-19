{ lib
, aiohttp
, attrs
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, poetry-core
, pytestCheckHook
, pythonRelaxDepsHook
, pythonOlder
, structlog
}:

buildPythonPackage rec {
  pname = "arsenic";
  version = "21.8";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "HENNGE";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-fsLo22PR9WdX2FazPgr8B8dFq6EM1LLTpRFGEm/ymCE=";
  };

  patches = [
    # Switch to poetry-core, https://github.com/HENNGE/arsenic/pull/160
    (fetchpatch {
      name = "switch-to-poetry-core.patch";
      url = "https://github.com/HENNGE/arsenic/commit/ca82894a5f1e832ab9283a245258b334bdd48855.patch";
      hash = "sha256-ECCUaJF4MRmFOKH1C6HowJ+zmbEPPiS7h9DlKw5otZc=";
    })
  ];

  pythonRelaxDeps = [
    "structlog"
  ];

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    aiohttp
    attrs
    structlog
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # Depends on asyncio_extras which is not longer maintained
  doCheck = false;

  pythonImportsCheck = [
    "arsenic"
  ];

  meta = with lib; {
    description = "WebDriver implementation for asyncio and asyncio-compatible frameworks";
    homepage = "https://github.com/HENNGE/arsenic/";
    changelog = "https://github.com/HENNGE/arsenic/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
