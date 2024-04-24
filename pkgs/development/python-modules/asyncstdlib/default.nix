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
  version = "3.12.3";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "maxfischer2781";
    repo = "asyncstdlib";
    rev = "refs/tags/v${version}";
    hash = "sha256-OLb4+7FFeVDW0ePyVJW8aaosouxlU/4Uq2ktvVLpDFY=";
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
