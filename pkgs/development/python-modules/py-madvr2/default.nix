{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "py-madvr2";
  version = "1.6.33";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "iloveicedgreentea";
    repo = "py-madvr";
    rev = "refs/tags/v${version}";
    hash = "sha256-z+PVLz9eApGJ94I/Jp0MyqNpKQwIemk8j+OyqFmIbgI=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "madvr" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/iloveicedgreentea/py-madvr/releases/tag/${lib.removePrefix "refs/tags/" src.rev}";
    description = "Control MadVR Envy over IP";
    homepage = "https://github.com/iloveicedgreentea/py-madvr";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
