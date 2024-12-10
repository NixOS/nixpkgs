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
  version = "5.5.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tkem";
    repo = "cachetools";
    rev = "refs/tags/v${version}";
    hash = "sha256-WG9PiUMVGaEXXHKbtOFEGjLiSbNnpSI2fXCogpGj1PI=";
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
