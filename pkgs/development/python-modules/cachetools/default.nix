{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "cachetools";
  version = "6.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tkem";
    repo = "cachetools";
    tag = "v${version}";
    hash = "sha256-seoyqkrRQpRiMd5GTEvenjirn173Hq40Zuk1u7TvMPI=";
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
