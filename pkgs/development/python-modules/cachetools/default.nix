{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "cachetools";
  version = "6.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tkem";
    repo = "cachetools";
    tag = "v${version}";
    hash = "sha256-o3Ice6w7Ovot+nsmTpsl/toosZuVbi9RvRGs07W4H0Y=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "cachetools" ];

  meta = with lib; {
    description = "Extensible memoizing collections and decorators";
    homepage = "https://github.com/tkem/cachetools";
    changelog = "https://github.com/tkem/cachetools/blob/v${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
