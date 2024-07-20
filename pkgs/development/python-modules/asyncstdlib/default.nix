{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "asyncstdlib";
  version = "3.12.4";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "maxfischer2781";
    repo = "asyncstdlib";
    rev = "refs/tags/v${version}";
    hash = "sha256-5xbz56/s448PIOZ4DN6NFcYYWXaebaZA3ApGAIMZXH4=";
  };

  build-system = [ flit-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "asyncstdlib" ];

  meta = with lib; {
    description = "Python library that extends the Python asyncio standard library";
    homepage = "https://asyncstdlib.readthedocs.io/";
    changelog = "https://github.com/maxfischer2781/asyncstdlib/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
