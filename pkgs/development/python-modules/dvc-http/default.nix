{
  lib,
  aiohttp-retry,
  buildPythonPackage,
  fetchFromGitHub,
  dvc-objects,
  fsspec,
  funcy,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "dvc-http";
  version = "2.32.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "iterative";
    repo = "dvc-http";
    tag = version;
    hash = "sha256-ru/hOFv/RcS/7SBpTJU8xFxdllmaiH4dV1ouS6GGKkY=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    aiohttp-retry
    dvc-objects
    fsspec
    funcy
  ];

  # Currently it's not possible to run the tests
  # ModuleNotFoundError: No module named 'dvc.testing'
  doCheck = false;

  pythonImportsCheck = [ "dvc_http" ];

  meta = {
    description = "HTTP plugin for dvc";
    homepage = "https://github.com/iterative/dvc-http";
    changelog = "https://github.com/iterative/dvc-http/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
