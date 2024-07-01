{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  typing-extensions,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "flexcache";
  version = "0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hgrecco";
    repo = "flexcache";
    rev = "refs/tags/${version}";
    hash = "sha256-MAbTe7NxzfRPzo/Wnb5SnPJvJWf6zVeYsaw/g9OJYSE=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [ typing-extensions ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "flexcache" ];

  meta = {
    description = "An robust and extensible package to cache on disk the result of expensive calculations";
    homepage = "https://github.com/hgrecco/flexcache";
    changelog = "https://github.com/hgrecco/flexcache/blob/${src.rev}/CHANGES";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
